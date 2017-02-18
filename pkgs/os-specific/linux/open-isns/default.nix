{ stdenv, openssl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "open-isns-${version}";
  version = "0.97";

  src = fetchFromGitHub {
    owner = "gonzoleeman";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "17aichjgkwjfp9dx1piw7dw8ddz1bgm5mk3laid2zvjks1h739k3";
  };

  propagatedBuildInputs = [ openssl ];
  outputs = [ "out" "lib" ];
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
