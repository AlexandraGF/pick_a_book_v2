defmodule PickABookWeb.BookControllerTest do
  use PickABookWeb.ConnCase

  alias PickABook.Books
  alias PickABook.Books.Book

  @create_attrs %{author: "some author", description: "some description", genre: "some genre", title: "some title"}
  @update_attrs %{author: "some updated author", description: "some updated description", genre: "some updated genre", title: "some updated title"}
  @invalid_attrs %{author: nil, description: nil, genre: nil, title: nil}

  def fixture(:book) do
    {:ok, book} = Books.create_book(@create_attrs)
    book
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get conn, book_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create book" do
    test "renders book when data is valid", %{conn: conn} do
      conn = post conn, book_path(conn, :create), book: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, book_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "author" => "some author",
        "description" => "some description",
        "genre" => "some genre",
        "title" => "some title"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, book_path(conn, :create), book: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update book" do
    setup [:create_book]

    test "renders book when data is valid", %{conn: conn, book: %Book{id: id} = book} do
      conn = put conn, book_path(conn, :update, book), book: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, book_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "author" => "some updated author",
        "description" => "some updated description",
        "genre" => "some updated genre",
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn = put conn, book_path(conn, :update, book), book: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete conn, book_path(conn, :delete, book)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, book_path(conn, :show, book)
      end
    end
  end

  defp create_book(_) do
    book = fixture(:book)
    {:ok, book: book}
  end
end