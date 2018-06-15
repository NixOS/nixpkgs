{ stdenv, openssl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "open-isns-${version}";
  version = "0.98";

  src = fetchFromGitHub {
    owner = "gonzoleeman";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "055gjwz5hxaj5jk23bf7dy9wbxk9m8cfgl1msbzjc60gr2mmcbdg";
  };

  propagatedBuildInputs = [ openssl ];
  outputs = [ "out" "lib" ];
  outputInclude = "lib";

  configureFlags = [ "--enable-shared" ];

  installFlags = "etcdir=$(out)/etc vardir=$(out)/var/lib/isns";
  installTargets = "install install_hdrs install_lib";

  meta = {
    description = "iSNS server and client for Linux";
    license = stdenv.lib.licenses.lgpl21;
    homepage = https://github.com/gonzoleeman/open-isns;
    platforms = stdenv.lib.platforms.linux;
  };
}
