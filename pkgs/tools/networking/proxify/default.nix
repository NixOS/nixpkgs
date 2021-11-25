{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "v${version}";
    sha256 = "0qhr51naa7ad80fsr12ka432071mfb1zq2wd852p1lyvy0mdf52s";
  };

  vendorSha256 = "0dynyhqh8jzmljqng1yh07r6k6zfzlsgh36rlynbdgcvjl7jdhnx";

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
