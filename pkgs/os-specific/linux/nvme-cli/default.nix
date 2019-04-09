{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nvme-cli-${version}";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "0k4qnxm9sgr4bqhg7c3g870f3jpawm5yp0vp0p031a9qgnzmklb9";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "NVM-Express user space tooling for Linux";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos tavyc ];
  };
}
