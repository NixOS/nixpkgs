{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "sauce-connect-${version}";
  version = "4.3.14";

  src = fetchurl (
    if stdenv.system == "x86_64-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
      sha256 = "0j900dijhq8rpjaf2hgqvz5gy3dgal6l1f7q6353m2v14jbwb786";
    } else if stdenv.system == "i686-linux" then {
      url = "https://saucelabs.com/downloads/sc-${version}-linux32.tar.gz";
      sha256 = "0nkgd1pyh21p0yg1zs0nzki0w4wsl1yy964lbz6mf6nrsjzqg54k";
    } else {
      url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
      sha256 = "1mcvxvqvfikkn19mjwws55x2abjp09jvjjg6b15x8w075bd9ql8g";
    }
  );

  buildInputs = [ unzip ];
  phases = "unpackPhase installPhase " + (if stdenv.system == "x86_64-darwin" then "" else "patchPhase");

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
