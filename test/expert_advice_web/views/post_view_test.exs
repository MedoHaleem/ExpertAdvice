defmodule ExpertAdviceWeb.PostViewTest do
  use ExpertAdviceWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    posts = [
      %ExpertAdvice.Accounts.Post{id: "1", title: "test", slug: "test", tags: []},
      %ExpertAdvice.Accounts.Post{id: "2", title: "test2", slug: "test2", tags: []}
    ]
      page = ExpertAdvice.Accounts.list_posts(%{}, "")

    content = render_to_string(ExpertAdviceWeb.PostView, "index.html", conn: conn, posts: posts ,page: page, tags: [], current_user: nil)

    assert String.contains?(content, "get answers to difficult questions")

    for post <- posts do
      assert String.contains?(content, post.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = ExpertAdvice.Accounts.change_post(%ExpertAdvice.Accounts.Post{})

    content =
      render_to_string(ExpertAdviceWeb.PostView, "new.html",
        conn: conn,
        changeset: changeset,
        tags: []
      )

    assert String.contains?(content, "New Question")
    end
end
