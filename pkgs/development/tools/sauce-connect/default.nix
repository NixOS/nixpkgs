{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.5.4";

   src = with stdenv.hostPlatform; fetchurl (
    assertOneOf "hostPlatform" stdenv.hostPlatform.system [ "x86_64-linux" "i686-linux" "x86_64-darwin" ]
    if stdenv.hostPlatform.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "1w8fw47q4bzpk5jfagmc0cbp69jdd6jcv2xl1gx91cbp7xd8mcbf";
    } else if stdenv.hostPlatform.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "1q8yy1cqz10y3bqfr86pwi47p6x62im0czzx269zcnnnh6danj3z";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "19lvaaby70s7d17hfnqwi9dd4camhbaap23naagw7ispdaj93mkx";
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
