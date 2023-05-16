{ lib, fetchurl, makeWrapper, runCommand, callPackage }:

let
<<<<<<< HEAD
  version = "1.3.7";
=======
  version = "1.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  programs = callPackage ./programs.nix { };

  webapp = fetchurl {
    url = "https://github.com/root-gg/plik/releases/download/${version}/plik-${version}-linux-amd64.tar.gz";
<<<<<<< HEAD
    hash = "sha256-Uj3I/ohgMr/Ud5xAZiBjsIW8bSdUeXXv9NYKLu8Aym8=";
=======
    sha256 = "sha256-UGzevhZDfQBoFgPZQIs5Ftgz1cUHGfY/IRSEWQHFVSQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

in
{

  inherit (programs) plik plikd-unwrapped;

  plikd = runCommand "plikd-${version}" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/libexec/plikd/{bin,webapp} $out/bin
    tar xf ${webapp} plik-${version}-linux-amd64/webapp/dist/
    mv plik-*/webapp/dist $out/libexec/plikd/webapp
    cp ${programs.plikd-unwrapped}/bin/plikd $out/libexec/plikd/bin/plikd
    makeWrapper $out/libexec/plikd/bin/plikd $out/bin/plikd \
      --chdir "$out/libexec/plikd/bin"
  '';
}
