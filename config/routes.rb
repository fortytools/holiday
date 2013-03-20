RepoGit::Application.routes.draw do

  match ':first/:second' => 'holidays#show'
  match ':first' => 'holidays#show'

  match 'api' => 'holidays#api', :as => :api
  match 'imprint' => 'holidays#imprint', :as => :imprint

  root :to => 'holidays#index'
end
