{ stdenv, openssl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "open-isns";
  version = "0.99";

  src = fetchFromGitHub {
    owner = "gonzoleeman";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "0m294aiv80rkihacw5094093pc0kd5bkbxqgs6i32jsglxy33hvf";
  };

  propagatedBuildInputs = [ openssl ];
  outputs = [ "out" "lib" ];
  outputInclude = "lib";

  configureFlags = [ "--enable-shared" ];

  installFlags = [ "etcdir=$(out)/etc" "vardir=$(out)/var/lib/isns" ];
  installTargets = [ "install" "install_hdrs" "install_lib" ];

  meta = {
    description = "iSNS server and client for Linux";
    license = stdenv.lib.licenses.lgpl21;
    homepage = https://github.com/gonzoleeman/open-isns;
    platforms = stdenv.lib.platforms.linux;
  };
}
