defmodule Goldilixir do
  def find_perfect_rhymes(keyword) do
    resp = Rhymebrain.get!(keyword).body
    |> Enum.filter_map(fn(word_match) -> word_match["score"] >= 300 end, &(&1["word"]))
  end

  def get_phrases(filename) do
    Phrasefile.get!(filename).body
    |> String.split("\n")

  end

  def filter_and_inject_puns(phrases, rhyming_words, keyword) do
    wordstring = Enum.join(rhyming_words, "|")
    regex = Regex.compile!("\\W(" <> wordstring <>")(?!\\w)", "i")
    phrases
    # |> Enum.filter(fn(phrase) -> Enum.any?(rhyming_words,
    #   fn(word) ->
    #     Regex.match?(Regex.compile!("\\W" <> word <>"(?!\\w)", "i"), phrase)
    #   end) end)
    |> Enum.filter_map(fn(phrase) -> Regex.match?(regex, phrase) end, &(String.replace(&1, regex, keyword)))
     # &(String.replace(&1, rhyming_words, keyword) )
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


