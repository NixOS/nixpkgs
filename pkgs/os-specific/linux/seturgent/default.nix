{ lib, stdenv, fetchurl, libX11, xorgproto, unzip }:

stdenv.mkDerivation {
  name = "seturgent-2012-08-17";

  src = fetchurl {
    url = "https://github.com/hiltjo/seturgent/archive/ada70dcb15865391e5cdcab27a0739a304a17e03.zip";
    sha256 = "0q1sr6aljkw2jr9b4xxzbc01qvnd5vk3pxrypif9yd8xjw4wqwri";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    libX11 xorgproto
  ];

  installPhase = ''
    mkdir -pv $out/bin
    mv seturgent $out/bin
  '';

  meta = {
      platforms = lib.platforms.linux;
      description = "Set an application's urgency hint (or not)";
      maintainers = [ lib.maintainers.yarr ];
      homepage = "https://github.com/hiltjo/seturgent";
      license = lib.licenses.mit;
  };
}
