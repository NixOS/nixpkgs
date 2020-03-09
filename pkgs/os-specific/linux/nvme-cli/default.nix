{ lib, stdenv, fetchFromGitHub, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "nvme-cli";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "12wp2wxmsw2v8m9bhvwvdbhdgx1md8iilhbl19sfzz2araiwi2x8";
  };

  nativeBuildInputs = [ pkgconfig ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  # To omit the hostnqn and hostid files that are impure and should be unique
  # for each target host:
  installTargets = [ "install-spec" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "NVM-Express user space tooling for Linux";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos tavyc ];
  };
}
