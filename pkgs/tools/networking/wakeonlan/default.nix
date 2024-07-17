{
  lib,
  stdenv,
  perlPackages,
  fetchFromGitHub,
  installShellFiles,
  shortenPerlShebang,
}:

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

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;

  nativeCheckInputs = [
    perlPackages.TestPerlCritic
    perlPackages.TestPod
    perlPackages.TestPodCoverage
  ];
  # Linting and formatting checks are of no interest for us.
  preCheck = ''
    rm -f t/93_pod_spell.t
  '';

  installPhase =
    ''
      install -Dt $out/bin wakeonlan
      installManPage blib/man1/wakeonlan.1
    ''
    + lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/wakeonlan
    '';

  meta = with lib; {
    description = "Perl script for waking up computers via Wake-On-LAN magic packets";
    homepage = "https://github.com/jpoliv/wakeonlan";
    license = licenses.artistic1;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "wakeonlan";
  };
}
