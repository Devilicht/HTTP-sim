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
    request_line = hd(String.split(request, "\r\n"))
    [method, path, _] = String.split(request_line, " ")

    %{
      method: method,
      path: path
    }
  end

  defp generate_response(request) do
    case request[:path] do
      "/" ->
        "HTTP/1.1 200 OK\r\n\r\n" <>
        "Bem-vindo ao meu servidor HTTP!"

      "/users" ->
        users = ["João", "Maria", "Pedro"]
        "HTTP/1.1 200 OK\r\n\r\n" <>
        "Usuários: #{inspect(users)}"

      _ ->
        "HTTP/1.1 404 Not Found\r\n\r\n" <>
        "Recurso não encontrado."
    end
  end
end
HttpServer.start(4085)
