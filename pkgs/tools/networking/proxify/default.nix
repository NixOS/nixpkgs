{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "refs/tags/v${version}";
    hash = "sha256-j2FuyoTCc9mcoI683xZkMCL6QXy0dGEheNaormlgUvY=";
  };

  vendorHash = "sha256-kPj3KBi8Mbsj4BW7Vf1w4mW8EN07FuqgFhAkkLCl8Bc=";

  meta = with lib; {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    changelog = "https://github.com/projectdiscovery/proxify/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
