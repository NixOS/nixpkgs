{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nvme-cli-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "16n0gg1zx4fgadcq94kx6bgysqw60jvybjwynk7mj3fzdbvzrqyh";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "NVM-Express user space tooling for Linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tavyc ];
  };
}
