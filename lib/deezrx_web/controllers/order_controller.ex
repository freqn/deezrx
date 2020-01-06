defmodule DeezrxWeb.OrderController do
  use DeezrxWeb, :controller

  alias Deezrx.Accounts

  def index(conn, _params) do
    render(conn, "index.html", orders: Accounts.list_orders())
  end

  def show(conn, %{"id" => order_id}) do
    render(conn, "show.html", order: Accounts.get_order!(order_id))
  end

  def new(conn, _params) do
    changeset = Accounts.change_order()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Accounts.create_order(order_params) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Order created")
        |> render("index.html", orders: Accounts.list_orders())

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def edit(conn, %{"id" => book_id}) do
  #   book = Store.get_book(book_id)
  #   changeset = Store.change_book(book)

  #   render(conn, "edit.html", changeset: changeset, book: book)
  # end

  # def update(conn, %{"id" => book_id, "book" => book_params}) do
  #   book = Store.get_book(book_id)

  #   case Store.update_book(book, book_params) do
  #     {:ok, book} ->
  #       conn
  #       |> put_flash(:info, "Book updated")
  #       |> redirect(to: "/")

  #     {:error, changeset} ->
  #       render(conn, "edit.html", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => book_id}) do
  #   book = Store.get_book(book_id)
  #   Store.delete_book(book)

  #   conn
  #   |> put_flash(:info, "#{book.title} deleted")
  #   |> redirect(to: "/")
  # end
end
