{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nvme-cli-${version}";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "0agnxfcwgnnimmxrdpg4lmiqc5ai9b4amk8krriw01lflxi3xzn0";
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
