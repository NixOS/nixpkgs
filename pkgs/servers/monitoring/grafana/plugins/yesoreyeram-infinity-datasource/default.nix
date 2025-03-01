{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "yesoreyeram-infinity-datasource";
  version = "2.11.0";
  zipHash = {
    x86_64-linux = "sha256-p5qLRImAuV8pqbwn+egbGMiPW6xdy8yQoRWdoiE4+B8=";
    aarch64-linux = "sha256-gmmFe2TrhPqTQz4aExx/kAgzqCcEvu2Az7SHmpJaMv8=";
    x86_64-darwin = "sha256-BuOMpZK+NoJx32f3pqcDI5szIW4bQl3+yFZI9zjzYE8=";
    aarch64-darwin = "sha256-ss/HxouKDZYZvF42KWJgMbOh9kSviH5oz6f/mrlcXk8=";
  };
  meta = with lib; {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
