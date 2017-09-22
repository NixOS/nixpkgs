{ stdenv, fetchurl }:

with stdenv.lib;

assert stdenv.isLinux;

let
  arch =
    if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else abort "Unsupported architecture";
  sha256 =
    if stdenv.system == "x86_64-linux" then "011xg1frhjavv6zj1y3da0yh7rl6v1ax6xy2g8fk3sry9bi2p4j3"
    else if stdenv.system == "i686-linux" then "03ml9xv19km99f0z7fpr21b1zkxvw7q39kjzd8wpb2pds51wnc62"
    else abort "Unsupported architecture";
  libraries = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];

in stdenv.mkDerivation rec {
  name = "logmein-hamachi-${version}";
  version = "2.1.0.174";

  src = fetchurl {
    url = "https://www.vpn.net/installers/${name}-${arch}.tgz";
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
