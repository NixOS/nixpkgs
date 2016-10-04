{ stdenv, fetchurl }:

with stdenv.lib;

assert stdenv.isLinux;

let
  arch =
    if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else abort "Unsupported architecture";
  sha256 =
    if stdenv.system == "x86_64-linux" then "0l8y8z8fqvxrypx3dp83mm3qr9shgpcn5h7x2k2z13gp4aq0yw6g"
    else if stdenv.system == "i686-linux" then "00nl442k4pij9fm8inlk4qrcvbnz55fbwf3sm3dgbzvd5jcgsa0f"
    else abort "Unsupported architecture";
  libraries = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];

in stdenv.mkDerivation rec {
  name = "logmein-hamachi-${version}";
  version = "2.1.0.165";

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
    homepage = "https://secure.logmein.com/products/hamachi/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
