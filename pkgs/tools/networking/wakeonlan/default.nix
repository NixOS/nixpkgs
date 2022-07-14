{ lib, perlPackages, fetchFromGitHub, installShellFiles }:

perlPackages.buildPerlPackage rec {
  pname = "wakeonlan";
  version = "0.42";

  src = fetchFromGitHub {
    owner = "jpoliv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zCOpp5iNrWwh2knBGWhiEyG9IPAnFRwH5jJLEVLBISM=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ installShellFiles ];
  # checkInputs = [ perl534Packages.TestPerlCritic perl534Packages.TestPod perl534Packages.TestPodCoverage ];
  doCheck = false;  # Missing package for https://github.com/genio/test-spelling to run tests

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
