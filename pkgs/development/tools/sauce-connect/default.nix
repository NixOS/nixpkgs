{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.4.8";

  src = fetchurl (
    if stdenv.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "1y6jmz0kdaz1fq9sirwxznzw52if6ypd0dp9mk7dkpipy0bx7pz6";
    } else if stdenv.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "13nd2g1z4nvc3fa30xr3jnkqcy3fv4751s7ws4l93p7x6nc4aw1n";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "0f8kcx7qd6bqbd74y6n83lb52zban9k631qkv1vyddvs9pjsxmpg";
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
