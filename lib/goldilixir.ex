defmodule Goldilixir do
  def find_perfect_rhymes(keyword) do
    resp = Rhymebrain.get!(keyword).body
    |> Enum.filter(fn(word_match) -> word_match["score"] >= 300 end)
    # |> IO.inspect
  end
end


defmodule Rhymebrain do
  use HTTPoison.Base

  def process_url(keyword) do
    "http://rhymebrain.com/talk?function=getRhymes&word=" <> keyword
  end

  def process_response_body(body) do
    Poison.Parser.parse!(body)
  end

end

