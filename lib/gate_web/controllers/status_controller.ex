defmodule GateWeb.StatusController do
  use GateWeb, :controller

  def status(conn, _params) do
    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, '{
	"application": [{
			"project": "cargox-api",
			"owner": "ordilei",
			"lock": true
		},
		{
			"project": "cargox-tms",
			"owner": "ordilei",
			"lock": true
		},
		{
			"project": "cargoforce",
			"owner": "ordilei",
			"lock": true
		}
	]

}')
  end
end