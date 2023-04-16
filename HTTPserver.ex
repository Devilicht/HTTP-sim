defmodule HttpServer do
  def start(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, {:packet, 0}, :reuseaddr])
    listen(socket)
  end

  defp listen(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    spawn(fn -> handle_request(client) end)
    listen(socket)
  end

  defp handle_request(socket) do
    {:ok, request} = read_request(socket)
    response = generate_response(request)
    :gen_tcp.send(socket, response)
    :gen_tcp.close(socket)
  end

  defp read_request(socket) do
    {:ok, request} = :gen_tcp.recv(socket, 0)
    parse_request(request)
  end

  defp parse_request(request) do
  end

  defp generate_response(request) do
  end
end
