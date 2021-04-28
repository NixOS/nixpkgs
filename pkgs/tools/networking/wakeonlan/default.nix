{ lib, perlPackages, fetchFromGitHub, installShellFiles }:

perlPackages.buildPerlPackage rec {
  pname = "wakeonlan";
  version = "0.41";

  src = fetchFromGitHub {
    owner = "jpoliv";
    repo = pname;
    rev = "wakeonlan-${version}";
    sha256 = "0m48b39lz0yc5ckx2jx8y2p4c8npjngxl9wy86k43xgsd8mq1g3c";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    install -Dt $out/bin wakeonlan
    installManPage blib/man1/wakeonlan.1
  '';

  meta = with lib; {
    description = "Perl script for waking up computers via Wake-On-LAN magic packets";
    homepage = "https://github.com/jpoliv/wakeonlan";
    license = licenses.artistic1;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
