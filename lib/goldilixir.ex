defmodule Goldilixir do
  def find_perfect_rhymes(keyword) do
    resp = Rhymebrain.get!(keyword).body
    |> Enum.filter(fn(word_match) -> word_match["score"] >= 300 end)
    # |> IO.inspect
  end

  def get_phrases(filename) do
    Phrasefile.get!(filename).body
    |> IO.puts
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

defmodule Phrasefile do
  use HTTPoison.Base

  def process_url(filename) do
    "https://raw.githubusercontent.com/drapergeek/elixirls_just_want_to_have_puns/master/phrases/" <> filename
  end
end


