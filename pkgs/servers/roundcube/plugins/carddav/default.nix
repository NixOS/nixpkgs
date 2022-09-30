{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "carddav";
  version = "4.4.3";

  src = fetchzip {
    url = "https://github.com/mstilkerich/rcmcarddav/releases/download/v${version}/carddav-v${version}.tar.gz";
    sha256 = "0xm2x6r0j8dpkybxq28lbwpbmxaa52z8jnw3yaszvmx04zsr5mn8";
  };
}
