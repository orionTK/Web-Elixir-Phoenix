defmodule BlogVttkieu.Paginator do
  alias BlogVttkieu.Paginator
  import Ecto.Query
  alias BlogVttkieu.Repo
  alias BlogVttkieu.Blog.Post
  alias BlogVttkieu.Blog
  defstruct [:entries, :page_number, :page_size, :total_pages]

  def new(query, params) do
    page_number = params |> Dict.get("page", 1) |> to_int
    page_size = params |> Dict.get("page_size", 4) |> to_int

    %Paginator{
      entries: entries(query, page_number, page_size),
      page_number: page_number,
      page_size: page_size,
      total_pages: 6
    }
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end

  defp entries(query, page_number, page_size) do
    offset = page_size * (page_number - 1)

    query
    |> limit([_], ^page_size)
    |> offset([_], ^offset)
    |> Repo.all
  end

  defp to_int(i) when is_integer(i), do: i
  defp to_int(s) when is_binary(s) do
    case Integer.parse(s) do
      {i, _} -> i
      :error -> :error
    end
  end

  defp total_pages(query,page_number,page_size) do
    count =  Post.count_posts(entries(query, page_number, page_size))


    ceiling(count / page_size)
  end


end
