{ lib, fetchurl, makeWrapper, runCommand, callPackage }:

let
  version = "1.3.6";

  programs = callPackage ./programs.nix { };

  webapp = fetchurl {
    url = "https://github.com/root-gg/plik/releases/download/${version}/plik-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-UGzevhZDfQBoFgPZQIs5Ftgz1cUHGfY/IRSEWQHFVSQ=";
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
