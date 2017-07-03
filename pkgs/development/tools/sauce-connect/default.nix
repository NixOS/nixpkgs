{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.4.7";

  src = fetchurl (
    if stdenv.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "0n7x9mvv6sww0h77k3d8rms78vah0j48ndsv4vnxq9znwjiglmva";
    } else if stdenv.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "1vwp8iqc5sk5kf7r86dld4767w4sm36hympnh1n2qza57ni7vy0g";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "1dwjysj3kjydz096bm5x0s1g3jm4a7y0qkgbsc6bwl44vxz81f66";
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
