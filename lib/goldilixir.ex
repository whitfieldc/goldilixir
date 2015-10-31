defmodule Goldilixir do
  def find_perfect_rhymes(keyword) do
    Rhymebrain.get!(keyword).body
    |> Enum.filter_map(fn(word_match) -> word_match["score"] >= 300 end, &(&1["word"]))
  end

  def get_phrases(filename) do
    Phrasefile.get!(filename).body
    |> String.split("\n")

  end

  def filter_and_inject_puns(phrase_path, keyword) do

    wordstring = Goldilixir.find_perfect_rhymes(keyword)
     |> Enum.join("|")
    regex = Regex.compile!("\\W(" <> wordstring <>")(?!\\w)", "i")
    doctored_keyword = " " <> String.capitalize(keyword)
    phrase_path
    |> Goldilixir.get_phrases
    |> Enum.filter_map(fn(phrase) -> Regex.match?(regex, phrase) end, &(String.replace(&1, regex, doctored_keyword)))
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


