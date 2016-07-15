defmodule Perentie.PageController do
  use Perentie.Web, :controller
  require IEx

  def index(conn, params) do
  	#IEx.pry 
  	render conn, "index.html"
  end

end
