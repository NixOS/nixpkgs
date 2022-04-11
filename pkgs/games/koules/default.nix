{ stdenv
, lib
, fetchurl
, fetchzip
, makeDesktopItem
, copyDesktopItems
, imake
, gccmakedep
, libX11
, libXext
, installShellFiles
}:

let
  debian-extras = fetchzip {
    url = "mirror://debian/pool/main/k/koules/koules_1.4-27.debian.tar.xz";
    sha256 = "0bq1rr6vxqmx2k0dhyrqnwwfiw4h2ycbj576v66vwr0jaq5plil3";
  };
in

stdenv.mkDerivation rec {
  pname = "koules";
  version = "1.4";

  src = fetchurl {
    url = "https://www.ucw.cz/~hubicka/koules/packages/${pname}${version}-src.tar.gz";
    sha256 = "06x2wkpns14kii9fxmxbmj5lma371qj00hgl7fc5kggfmzz96vy3";
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

  desktopItems = [ (makeDesktopItem {
    desktopName = "Koules";
    name = "koules";
    exec = "xkoules";
    icon = "koules";
    comment = "Push your enemies away, but stay away from obstacles";
    categories = [ "Game" "ArcadeGame" ];
  }) ];

  meta = with lib; {
    description = "Fast arcade game based on the fundamental law of body attraction";
    homepage = "https://www.ucw.cz/~hubicka/koules/English/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.iblech ];
  };
}
