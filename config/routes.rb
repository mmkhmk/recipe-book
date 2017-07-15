Rails.application.routes.draw do
  resources :recipes

  get '*path', controller: 'application', action: 'render_404'
end
