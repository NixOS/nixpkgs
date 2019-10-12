{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nvme-cli";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "08x0x7nq8v7gr8a4lrrhclkz6n8fxlhhizxl2nz56w1xmfghcnfv";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  # To omit the hostnqn and hostid files that are impure and should be unique
  # for each target host:
  installTargets = "install-spec";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "NVM-Express user space tooling for Linux";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos tavyc ];
  };
}
