{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "refs/tags/v${version}";
    hash = "sha256-InHo5nfgCLDxciwjaB9tamV6MGEM3DlRGU00Ng2SfVY=";
  };

  vendorHash = "sha256-GPkxUU9HXLWnj+qjee/CuSE683l2V22cH9KBP2ssaXc=";

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
