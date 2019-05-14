Rails.application.routes.draw do
  get '/', to: 'games#new', as: :new
  get 'score', to: 'games#score', as: :score

  post 'score', to: 'games#score'
end
