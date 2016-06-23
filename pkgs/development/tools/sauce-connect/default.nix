{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.3.16";

  src = fetchurl (
    if stdenv.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "0i4nvb1yd9qnbgbfc8wbl7ghpmba2jr98hj4y4j4sbjfk65by3xw";
    } else if stdenv.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "1w9b1584kh1n4fw0wxbyslxp6w09if53fv4p9zz7vn4smm79ndfz";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "1vhz2j30p285blspg7prr9bsah6f922p0mv7mhmk6xzgf6fgn764";
    }
  );

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" ]
   ++ (lib.optionals (stdenv.system != "x86_64-darwin") [ "patchPhase" ])
   ++ [ "installPhase " ];

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
