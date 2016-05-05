{ stdenv, fetchurl }:

with stdenv.lib;

assert stdenv.isLinux;

let
  arch =
    if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else abort "Unsupported architecture";
  sha256 =
    if stdenv.system == "x86_64-linux" then "1j9sba5prpihlmxr98ss3vls2qjfc6hypzlakr1k97z0a8433nif"
    else if stdenv.system == "i686-linux" then "100x6gib2np72wrvcn1yhdyn4fplf5x8xm4x0g77izyfdb3yjg8h"
    else abort "Unsupported architecture";
  libraries = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];

in stdenv.mkDerivation rec {
  name = "logmein-hamachi-2.1.0.139";

  src = fetchurl {
    url = "https://secure.logmein.com/labs/${name}-${arch}.tgz";
    inherit sha256;
  };

  installPhase = ''
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${libraries} \
      hamachid
    install -D -m755 hamachid $out/bin/hamachid
    ln -s $out/bin/hamachid $out/bin/hamachi
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "A hosted VPN service that lets you securely extend LAN-like networks to distributed teams";
    homepage = https://secure.logmein.com/products/hamachi/;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
