{ stdenv, haskellPackages, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nix-script-${version}";
  version = "2015-09-22";

  src  = fetchFromGitHub {
    owner  = "bennofs";
    repo   = "nix-script";
    rev    = "83064dc557b642f6748d4f2372b2c88b2a82c4e7";
    sha256 = "0iwclyd2zz8lv012yghfr4696kdnsq6xvc91wv00jpwk2c09xl7a";
  };

  buildInputs  = [
    (haskellPackages.ghcWithPackages (hs: with hs; [ posix-escape ]))
  ];

  phases = [ "buildPhase" "installPhase" "fixupPhase" ];
  buildPhase = ''
    mkdir -p $out/bin
    ghc -O2 $src/nix-script.hs -o $out/bin/nix-script -odir . -hidir .
  '';
  installPhase = ''
    ln -s $out/bin/nix-script $out/bin/nix-scripti
  '';

  meta = with stdenv.lib; {
    description = "A shebang for running inside nix-shell.";
    homepage    = https://github.com/bennofs/nix-script;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ bennofs rnhmjoj ];
    platforms   = haskellPackages.ghc.meta.platforms;
  };
}
