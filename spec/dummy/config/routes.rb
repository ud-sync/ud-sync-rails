Rails.application.routes.draw do
  mount UdSync::Engine => "/ud_sync"
end
