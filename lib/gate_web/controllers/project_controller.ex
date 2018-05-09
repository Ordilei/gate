defmodule GateWeb.ProjectController do
  use GateWeb, :controller

  @storage_server Application.get_env(:gate, :storage)

  def lock(conn, project, server, user, reason) do
    if free?(project, server) do
      do_lock(project, server, user, reason)
      conn
      |> put_resp_content_type("text/json")
      |> send_resp(200, "Locked")
    else
      conn
      |> send_resp(400, {:error, lock_info(project, server)})
    end
  end

  def unlock(conn, _params) do
  	#TODO
  end

  defp do_lock(project, server, user, reason) do
    @storage_server.set("#{project}/#{server}", :user, user)
    @storage_server.set("#{project}/#{server}", :reason, reason)
    @storage_server.set("#{project}/#{server}", :locked_at, now)
  end

end