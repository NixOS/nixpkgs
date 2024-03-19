{ lib, stdenv, openssl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "open-isns";
  version = "0.102";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "sha256-Vz6VqqvEr0f8AdN9NcVnruapswmoOgvAXxXSfrM3yRA=";
  };

  propagatedBuildInputs = [ openssl ];
  outputs = [ "out" "lib" ];
  outputInclude = "lib";

  configureFlags = [ "--enable-shared" ];

  installFlags = [ "etcdir=$(out)/etc" "vardir=$(out)/var/lib/isns" ];
  installTargets = [ "install" "install_hdrs" "install_lib" ];

  meta = with lib; {
    description = "iSNS server and client for Linux";
    license = licenses.lgpl21Only;
    homepage = "https://github.com/open-iscsi/open-isns";
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
