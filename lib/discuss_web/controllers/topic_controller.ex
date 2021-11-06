defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias DiscussWeb.Topic

  def index(conn, _options) do
    topics = Discuss.Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _options) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic} = _params) do
    changeset = Topic.changeset(%Topic{}, topic)
    # IO.inspect(changeset)
    case Discuss.Repo.insert(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic is created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Discuss.Repo.get(Topic, topic_id)
    render(conn, "show.html", topic: topic)
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Discuss.Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params} = _params) do
    topic = Discuss.Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic, topic_params)

    case Discuss.Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic is updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = Discuss.Repo.get(Topic, topic_id)

    case Discuss.Repo.delete(topic) do
      {:ok, _} ->
        conn
        |> put_flash(:error, "Topic is deleted")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Fail to delete topic")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end
end
