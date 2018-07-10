defmodule Pinger do
  def start_link(url) do
    spawn_link(fn -> run(url) end)
  end

  def run(url) do
    Application.ensure_all_started(:inets)
    loop(url)
  end

  def loop(url) do
    case :httpc.request(:get, {url, []}, [], []) do
      {:ok, {{_, code, message}, _headers, _body}} ->
        IO.puts("#{inspect code} - #{inspect message}")
      the_rest ->
        the_rest
    end
    :timer.sleep(1000)
    loop(url)
  end
end
