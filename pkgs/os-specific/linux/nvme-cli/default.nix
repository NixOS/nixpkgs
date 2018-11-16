{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nvme-cli-${version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "0pp00yzj9c398bzd7jrjhzr7q1pk7d069dnbzyq1qqssszgcj599";
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
