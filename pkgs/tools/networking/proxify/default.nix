{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "v${version}";
    sha256 = "sha256-jITmLJHKTIXnQRUTLaXQPv57gJSbD+6AfJNl36AemR0=";
  };

  vendorSha256 = "sha256-Yf1edWWHao2A+iY/5N14mvtvLP+IJDZEEB0Voj47sCs=";

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
