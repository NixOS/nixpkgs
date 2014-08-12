{ stdenv, fetchurl, mono, makeWrapper, lua
, SDL2, freetype, openal, systemd, pkgconfig
}:

let
  version = "20140608";
in stdenv.mkDerivation rec {
  name = "openra-${version}";

  meta = with stdenv.lib; {
    description = "Real Time Strategy game engine recreates the C&C titles";
    homepage    = "http://www.open-ra.org/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/OpenRA/OpenRA/archive/release-${version}.tar.gz";
    sha256 = "0k7siysxb2nk7zzrl7vz1cwky4nla46ixzgxgc8rq6ilmlidh96b";
  };

  dontStrip = true;

  buildInputs = [ lua ];
  nativeBuildInputs = [ mono makeWrapper lua pkgconfig ];

  patchPhase = ''
    sed -i 's/^VERSION.*/VERSION = release-${version}/g' Makefile
    substituteInPlace configure --replace /bin/bash "$shell" --replace /usr/local/lib "${lua}/lib"
  '';

  preConfigure = ''
    makeFlags="prefix=$out"
    make version
  '';

  postInstall = with stdenv.lib; let
    runtime = makeLibraryPath [ SDL2 freetype openal systemd lua ];
  in ''
    wrapProgram $out/lib/openra/launch-game.sh \
      --prefix PATH : "${mono}/bin" \
      --set PWD $out/lib/openra/ \
      --prefix LD_LIBRARY_PATH : "${runtime}"
      
    mkdir -p $out/bin
    echo "cd $out/lib/openra && $out/lib/openra/launch-game.sh" > $out/bin/openra
    chmod +x $out/bin/openra
  '';
}
