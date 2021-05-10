defmodule BlogVttkieuWeb.Router do
  use BlogVttkieuWeb, :router
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/" do
  #   plug :accepts, ["json"]

  #   pow_routes()
  # end

  scope "/", BlogVttkieuWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController do
    resources "/comments", CommentController, only: [:create]
    end
    resources "/users", UserController
    # resources "/session", SessionController
    get "/signin", SessionController, :new
    post "signin", SessionController, :create
    post "signup", SessionController, :register
    delete "/sign_out", SessionController, :delete
    get "/signup", SessionController, :newsignup
  end


  # Other scopes may use custom stacks.
  # scope "/api", BlogVttkieuWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BlogVttkieuWeb.Telemetry
    end
  end
end
