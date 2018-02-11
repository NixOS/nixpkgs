{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nvme-cli-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "1nl5hl5am8djwmrw1xxnd9ahp7kyzyj0yh1nxgmx43pn3d61n0vz";
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
