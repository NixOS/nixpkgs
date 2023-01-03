{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "v${version}";
    sha256 = "sha256-0zXWW6U+x9W+fMsvYTfWRdoftsQCp2JXXkfbqS63Svk=";
  };

  vendorSha256 = "sha256-OldZyaPROtnPZPczFjn+kl61TI5zco/gM2MuPn2gYjo=";

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
