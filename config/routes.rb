RepoGit::Application.routes.draw do

  # Explicitly matching automatic favicon request, which otherwise will be matched below
  match 'favicon.ico' => proc { [404, {}, ['']] }

  match 'imprint' => 'holidays#imprint', as: :imprint

  match 'today' => 'holidays#index', as: :today

  match ':first/:second' => 'holidays#show', as: :holidays_two
  match ':first' => 'holidays#show', as: :holidays_one


  root :to => 'holidays#index'
end
