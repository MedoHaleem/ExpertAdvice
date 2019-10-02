defmodule ExpertAdviceWeb.Router do
  use ExpertAdviceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ExpertAdviceWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExpertAdviceWeb do
    pipe_through :browser

    get "/", PostController, :index
    get "/ask", PostController, :new
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/posts", PostController do
      post "/answer", AnswerController, :create
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExpertAdviceWeb do
  #   pipe_through :api
  # end
end
