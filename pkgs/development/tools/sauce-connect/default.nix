{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.4.12";

  src = fetchurl (
    if stdenv.hostPlatform.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "1yqvx64bgiq27hdhwkzgmzyib8pbjn1idpq6783srxq64asf6iyw";
    } else if stdenv.hostPlatform.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "02kib56lv4lhwkj5r15484lvvbyjvf9ydi5vccsmxgsxrzmddnl6";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "1gqsbw9f6nachk3c86knbqq417smqyf19mi63fmrfxrbxzy2fkv2";
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
