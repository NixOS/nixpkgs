{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "contextmenu";
  version = "3.3.1";

  src = fetchzip {
    url = "https://github.com/johndoh/roundcube-contextmenu/archive/refs/tags/${version}.tar.gz";
    sha256 = "0aya3nv8jwfvd9rlvxfxnyfpdcpw858745xal362l3zzkbkhcrmb";
  };
}
