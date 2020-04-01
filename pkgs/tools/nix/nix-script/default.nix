{ stdenv, haskellPackages, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "nix-script";
  version = "2020-03-23";

  src  = fetchFromGitHub {
    owner  = "bennofs";
    repo   = "nix-script";
    rev    = "7706b45429ff22c35bab575734feb2926bf8840b";
    sha256 = "0yiqljamcj9x8z801bwj7r30sskrwv4rm6sdf39j83jqql1fyq7y";
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
    homepage    = "https://github.com/bennofs/nix-script";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ bennofs rnhmjoj ];
    platforms   = haskellPackages.ghc.meta.platforms;
  };
}
