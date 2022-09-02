{ stdenv
, lib
, fetchurl
, fetchzip
, copyDesktopItems
, gccmakedep
, imake
, installShellFiles
, libX11
, libXext
, makeDesktopItem
}:

let
  debian-extras = fetchzip {
    url = "mirror://debian/pool/main/k/koules/koules_1.4-27.debian.tar.xz";
    hash = "sha256-g0Z6C1YSZL6N2eYUuZgXkPDoOLc4e9jAFL3ivk3OAS8=";
  };
in
stdenv.mkDerivation rec {
  pname = "koules";
  version = "1.4";

  src = fetchurl {
    url = "https://www.ucw.cz/~hubicka/koules/packages/${pname}${version}-src.tar.gz";
    hash = "sha256-w2+T/q/uvVmYO/RBACQOZ6hKi6yr1+5SjJMEbe/kohs=";
  };

  nativeBuildInputs = [ imake gccmakedep installShellFiles copyDesktopItems ];
  buildInputs = [ libX11 libXext ];

  # Debian maintains lots of patches for koules. Let's include all of them.
  prePatch = ''
    patches="$patches $(cat ${debian-extras}/patches/series | sed 's|^|${debian-extras}/patches/|')"
  '';

  postPatch = ''
    # We do not want to depend on that particular font to be available in the
    # xserver, hence substitute it by a font which is always available
    sed -ie 's:-schumacher-clean-bold-r-normal--8-80-75-75-c-80-\*iso\*:fixed:' xlib/init.c
  '';

  preBuild = ''
    cp xkoules.6 xkoules.man  # else "make" will not succeed
    sed -ie "s:^SOUNDDIR\s*=.*:SOUNDDIR=$out/lib:" Makefile
    sed -ie "s:^KOULESDIR\s*=.*:KOULESDIR=$out:" Makefile
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 xkoules $out/bin/xkoules
    install -Dm755 koules.sndsrv.linux $out/lib/koules.sndsrv.linux
    install -m644 sounds/* $out/lib/
    install -Dm644 Koules.xpm $out/share/pixmaps/koules.xpm
    installManPage xkoules.6
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Koules";
      name = "koules";
      exec = "xkoules";
      icon = "koules";
      comment = "Push your enemies away, but stay away from obstacles";
      categories = [ "Game" "ArcadeGame" ];
    })
  ];

  meta = with lib; {
    homepage = "https://www.ucw.cz/~hubicka/koules/English/";
    description = "Fast arcade game based on the fundamental law of body attraction";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.iblech ];
    platforms = platforms.linux;
  };
}
