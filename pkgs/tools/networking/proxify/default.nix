{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "refs/tags/v${version}";
    hash = "sha256-aoge1K1T4jgh8TFN8nFIjFehmz/o1UefbzEbV85dHTk=";
  };

  vendorHash = "sha256-ingumSn4EDdw1Vgwm/ghQTsErqFVFZtjNfwfDwdJ/2s=";

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
