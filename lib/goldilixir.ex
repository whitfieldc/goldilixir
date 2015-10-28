defmodule Goldilixir do
  def find_perfect_rhymes(keyword) do
    resp = Rhymebrain.get!(keyword).body
    |> Enum.filter_map(fn(word_match) -> word_match["score"] >= 300 end, &(&1["word"]))
  end

  def get_phrases(filename) do
    Phrasefile.get!(filename).body
    |> String.split("\n")
    |> Enum.map(fn(phrase) -> phrase end)

  end

  def filter_and_inject_puns(phrases, rhyming_words, keyword) do
    phrases
    |> Enum.filter_map(fn(phrase) -> Enum.each(rhyming_words, fn(word) ->
#### regex to match word to phrase without including matches to part of a word

      ) end, &(String.replace(&1, rhyming_words, keyword) ))
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


