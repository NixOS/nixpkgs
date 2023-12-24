{ lib, stdenv, rWrapper, rPackages, ... }:

stdenv.mkDerivation {
  pname = "resorter";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    install resorter.r $out/bin/resorter
  '';

  buildInputs = [
    (rWrapper.override {
      packages = with rPackages; [ BradleyTerry2 argparser ];
    })
  ];

  meta = with lib; {
    description = "A tool to sort a list of items based on pairwise comparisons";
    homepage = "https://gwern.net/resorter";
    license = licenses.cc0;
    maintainers = with maintainers; [ max-niederman ];
    platforms = platforms.all;
  };
}
