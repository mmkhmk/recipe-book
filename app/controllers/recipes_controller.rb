class RecipesController < ApplicationController
  before_action :generate_flash_message!, only: [:create, :update]
  before_action :sanitize_params!, only: [:create, :update]

  def index
    @recipes = Recipe.search(params)
    @tag     = Tag.find_by(id: params[:tag]) if params[:tag].present?
    @tags    = Tag.all unless params[:tag].present?
  end

  def new
    @recipe = Recipe.new
    @recipe.build_picture
    @recipe.build_tag
    @recipe.ingredients.build
    @recipe.steps.build
  end

  def edit
    @recipe = Recipe.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @recipe
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @recipe
  end

  def create
    if flash[:message]
      redirect_to new_recipe_path and return
    end
    @tag = Tag.find_by(name: tag_name)
    Recipe.transaction do
      unless @tag
        @tag = Tag.new(name: tag_name)
        @tag.save!
      end
      @recipe = Recipe.new(recipe_params)
      @recipe.tag_id = @tag.id
      @recipe.save!
    end
    redirect_to recipes_path
  end

  def update
    @recipe = Recipe.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @recipe
    if flash[:message]
      redirect_to edit_recipe_path(@recipe) and return
    end

    @tag    = Tag.find_by(name: tag_name)
    Recipe.transaction do
      unless @tag
        @tag = Tag.new(name: tag_name)
        @tag.save!
      end
      @recipe.attributes = recipe_params
      @recipe.tag_id = @tag.id
      @recipe.save! if @recipe.changed?
    end
    redirect_to recipe_path(@recipe)
  end

  def destroy
    @recipe = Recipe.find_by(id: params[:id])
    @recipe.destroy!
    redirect_to recipes_path
  end

  private

  def sanitize_params!
    all_params[:cook_time]   = all_params[:cook_time].to_i
    all_params[:serving_for] = all_params[:serving_for].to_i
  end

  def generate_flash_message!
    missing_params = []
    flash[:message] = nil
    missing_params << "タイトル" if all_params[:title].blank?
    missing_params << "説明" if all_params[:description].blank?
    missing_params << "調理時間" if all_params[:cook_time].blank?
    missing_params << "何人前" if all_params[:serving_for].blank?
    missing_params << "料理のコツ・ポイント" if all_params[:cook_point].blank?
    missing_params << "写真" if all_params[:picture_attributes].blank?
    missing_params << "材料" if all_params[:ingredients_attributes].blank?
    missing_params << "手順" if all_params[:steps_attributes].blank?
    return if missing_params.blank?
    flash[:message] = "未入力の項目があります > #{missing_params.join(', ')}"
  end

  def all_params
    params.require(:recipe)
  end

  def recipe_params
    all_params.permit(
      :title,
      :description,
      :cook_time,
      :serving_for,
      :cook_point,
      picture_attributes: [:id, :recipe_id, :picture],
      ingredients_attributes: [:recipe_id, :name, :quantity, :_destroy],
      steps_attributes: [:recipe_id, :description, :_destroy]
    )
  end

  def tag_name
    recipe_tag_params = all_params.permit(
      tag_attributes: [:name]
    )
    recipe_tag_params[:tag_attributes][:name]
  end
end