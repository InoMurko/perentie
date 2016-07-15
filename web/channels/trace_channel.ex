defmodule Perentie.TraceChannel do
  use Phoenix.Channel
  intercept ["trace:nodes","trace:start"]

  
  def forward(_tbl, trace) do
    data = Perentie.Serializer.encode(trace)
    case data do
        :skip -> :ok
      _ ->
        Perentie.Endpoint.broadcast("trace", "trace:start", data)
        :ok
    end 
  end

  def join("trace", _message, socket) do
    {:ok, socket}
  end

  def handle_in("trace:nodes", _message, socket) do
    nodes = :goanna_api.nodes() |> Perentie.Serializer.encode
    push socket, "trace:nodes", nodes
    {:noreply, socket}
  end

  def handle_out("trace:nodes", _message, socket) do
    {:noreply, socket}
  end

  def handle_out("trace:start", message, socket) do
    push socket, "trace:start", message
    {:noreply, socket}
  end

end