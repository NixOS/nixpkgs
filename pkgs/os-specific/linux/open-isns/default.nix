{ lib, stdenv, openssl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "open-isns";
  version = "0.101";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "1g7kp1j2f8afsach6sbl4k05ybz1yz2s8yg073bv4gnv48gyxb2p";
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
