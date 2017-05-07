{ mkDerivation, base, cabal-install, directory, fetchFromGitHub
, filepath, intero, optparse-applicative, posix-escape, split
, stdenv, unix
}:
mkDerivation {
  pname = "intero-nix-shim";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "michalrus";
    repo = "intero-nix-shim";
    rev = "0.1.2";
    sha256 = "0p1h3w15bgvsbzi7f1n2dxxxz9yq7vmbxmww5igc5d3dm76skgzg";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base directory filepath optparse-applicative posix-escape split
    unix
  ];
  postInstall = ''
    mkdir -p $out/libexec
    ln -s ${cabal-install}/bin/cabal  $out/libexec
    ln -s ${intero       }/bin/intero $out/libexec
  '';
  homepage = "https://github.com/michalrus/intero-nix-shim";
  license = stdenv.lib.licenses.asl20;
}
