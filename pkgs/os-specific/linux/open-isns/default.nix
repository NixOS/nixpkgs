{ stdenv, openssl, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "open-isns-${version}";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "gonzoleeman";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "1c2x3yf9806gbjsw4xi805rfhyxk353a3whqvpccz8dwas6jajwh";
  };

  propagatedBuildInputs = [ openssl ];
  outputs = ["out" "lib" ];
  outputInclude = "lib";

  installFlags = "etcdir=$(out)/etc vardir=$(out)/var/lib/isns";
  installTargets = "install install_hdrs install_lib";

  meta = {
    description = "iSNS server and client for Linux";
    license = stdenv.lib.licenses.lgpl21;
    homepage = https://github.com/gonzoleeman/open-isns;
    platforms = stdenv.lib.platforms.linux;
  };
}
