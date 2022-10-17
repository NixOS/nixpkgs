{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "v${version}";
    sha256 = "sha256-6YsduuiPgwxcSkqEcMxEhubte87IxWV9Qa1Vyv0Pd5w=";
  };

  vendorSha256 = "sha256-ewPimn70cheToU33g3p9s0MHxQdbKiqhGReKLgiHOSI=";

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
