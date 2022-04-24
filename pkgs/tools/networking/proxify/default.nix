{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "v${version}";
    sha256 = "sha256-g6HYwcQ4zAPLdu2o7oS1uWyFMp5FpGuJVXPtfAqYHJc=";
  };

  vendorSha256 = "sha256-JJhxVfvcqOW6zvg+m8lIcrRgxIStFKXMuWo1BMmIv+o=";

  meta = with lib; {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
