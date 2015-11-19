Rails.application.routes.draw do
  root to: 'application#index'
  get ':hash/:slug' => 'application#navigator'
  get ':hash/:slug/results/:id' => 'application#navigator'
  mount API => '/api'
end
