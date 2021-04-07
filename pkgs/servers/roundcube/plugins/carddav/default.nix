{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "carddav";
  version = "3.0.3";

  src = fetchzip {
    url = "https://github.com/blind-coder/rcmcarddav/releases/download/v${version}/carddav-${version}.tar.bz2";
    sha256 = "0scqxqfwv9r4ggaammmjp51mj50qc5p4jmjliwjvcwyjr36wjq3z";
  };
}
