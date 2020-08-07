{ fetchFromGitHub, stdenv, go, xorg, gnused }:
stdenv.mkDerivation
{
  pname = "ibus-bamboo";
  version = "v0.6.5";

  src = fetchFromGitHub {
    owner = "BambooEngine";
    repo = "ibus-bamboo";
    rev = "3f4c148228c239c80d787cca207604f6acd95660";
    sha256= "00fs9mlcvyrybm356q7yl5g2s03j6drsgc82qkx5hx73i56pyd0j";
  };

  nativeBuildInputs = [ gnused ];
  buildInputs = [ go xorg.libX11 xorg.libXtst xorg.libXi ];

  patchPhase = "sed -i 's|PREFIX=/usr|PREFIX=|' Makefile";
  buildPhase = "GOCACHE=$NIX_BUILD_TOP/gocache make build";
  installPhase = "DESTDIR=$out GOCACHE=$NIX_BUILD_TOP/gocache make install";
  fixupPhase = ''
    sed -i "s|/usr/lib/ibus-engine-bamboo|$out/lib/ibus-engine-bamboo|" $out/share/ibus/component/bamboo.xml
    sed -i "s|/usr/share/ibus-bamboo|$out/share/ibus-bamboo|" $out/share/ibus/component/bamboo.xml
    sed -i "s|>Bamboo<|>bamboo<|" $out/share/ibus/component/bamboo.xml
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "IBus interface to the vietnamese input method";
    homepage = "https://github.com/BambooEngine";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
