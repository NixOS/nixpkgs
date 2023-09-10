{ stdenv, lib, fetchurl, zlib, unzip }:

stdenv.mkDerivation rec {
  pname = "sauce-connect";
  version = "4.5.4";

  src = fetchurl (
    if stdenv.hostPlatform.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "1w8fw47q4bzpk5jfagmc0cbp69jdd6jcv2xl1gx91cbp7xd8mcbf";
    } else if stdenv.hostPlatform.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "1h9n1mzmrmlrbd0921b0sgg7m8z0w71pdb5sif6h1b9f97cp353x";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "0rkyd402f1n92ad3w1460j1a4m46b29nandv4z6wvg2pasyyf2lj";
    }
  );

  nativeBuildInputs = [ unzip ];

  patchPhase = lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${lib.makeLibraryPath [zlib]}" \
      bin/sc
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  dontStrip = true;

  meta = with lib; {
    description = "A secure tunneling app for executing tests securely when testing behind firewalls";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    homepage = "https://docs.saucelabs.com/reference/sauce-connect/";
    maintainers = with maintainers; [offline];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
