{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.3.13";

  src = fetchurl (
    if stdenv.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha1 = "0d7d2dc12766ac137e62a3e4dad3025b590f9782";
    } else if stdenv.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha1 = "ee2c3002eae3b29df801a2ac1db77bb5f1c97bcc";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha1 = "ihr4ynnyi464pafgqyl5xkhfi13yi76j";
    }
  );

  buildInputs = [ unzip ];
  phases = "unpackPhase installPhase" + (if stdenv.system == "x86_64-darwin" then "" else "patchPhase");

  patchPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${makeLibraryPath [zlib]}" \
      bin/sc
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  dontStrip = true;

  meta = {
    description = "A secure tunneling app for executing tests securely when testing behind firewalls";
    license = licenses.unfree;
    homepage = https://docs.saucelabs.com/reference/sauce-connect/;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
