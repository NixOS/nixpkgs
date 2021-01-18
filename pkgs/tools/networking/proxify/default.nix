{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "v${version}";
    sha256 = "15j2q9zrs8bdf72jgldkai3xbi4irk69wyjzv48r74rdgf2k49gn";
  };

  vendorSha256 = "1x78n88ri8kph827k03x1q06zpbbbp7793xsvc376ljda5n6bqig";

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
