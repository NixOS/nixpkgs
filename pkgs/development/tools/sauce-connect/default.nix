{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.5.1";

  src = fetchurl (
    if stdenv.hostPlatform.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "0lpfvlax7k8r65bh01i3kzrlmx0vnm9vhhir8k1gp2f4rv6z4lyx";
    } else if stdenv.hostPlatform.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "1h9n1mzmrmlrbd0921b0sgg7m8z0w71pdb5sif6h1b9f97cp353x";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "0rkyd402f1n92ad3w1460j1a4m46b29nandv4z6wvg2pasyyf2lj";
    }
  );

  buildInputs = [ unzip ];

  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
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
