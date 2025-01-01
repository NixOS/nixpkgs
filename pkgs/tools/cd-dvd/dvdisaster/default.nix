{ lib
, stdenv
, fetchurl
, gettext
, pkg-config
, which
, glib
, gtk2
, enableSoftening ? true
}:

stdenv.mkDerivation rec {
  pname = "dvdisaster";
  version = "0.79.10";

  src = fetchurl {
    url = "https://dvdisaster.jcea.es/downloads/${pname}-${version}.tar.bz2";
    hash = "sha256-3Qqf9i8aSL9z2uJvm8P/QOPp83nODC3fyLL1iBIgf+g=";
  };

  nativeBuildInputs = [ gettext pkg-config which ];
  buildInputs = [ glib gtk2 ];

  patches = lib.optionals enableSoftening [
    ./encryption.patch
    ./dvdrom.patch
  ];

  postPatch = ''
    patchShebangs ./
    sed -i 's/dvdisaster48.png/dvdisaster/' contrib/dvdisaster.desktop
    substituteInPlace scripts/bash-based-configure \
      --replace 'if (make -v | grep "GNU Make") > /dev/null 2>&1 ;' \
                'if make -v | grep "GNU Make" > /dev/null 2>&1 ;'
  '';

  configureFlags = [
    # Explicit --docdir= is required for on-line help to work:
    "--docdir=share/doc"
    "--with-nls=yes"
    "--with-embedded-src-path=no"
  ] ++ lib.optional (stdenv.hostPlatform.isx86_64) "--with-sse2=yes";

  # fatal error: inlined-icons.h: No such file or directory
  enableParallelBuilding = false;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    pushd regtest

    mkdir -p "$TMP"/{log,regtest}
    substituteInPlace common.bash \
      --replace /dev/shm "$TMP/log" \
      --replace /var/tmp "$TMP"

    for test in *.bash; do
      case "$test" in
      common.bash)
        echo "Skipping $test"
        continue ;;
      *)
        echo "Running $test"
        ./"$test"
      esac
    done

    popd
    runHook postCheck
  '';

  postInstall = ''
    rm -f $out/bin/dvdisaster-uninstall.sh
    mkdir -pv $out/share/applications
    cp contrib/dvdisaster.desktop $out/share/applications/

    for size in 16 24 32 48 64; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps/
      cp contrib/dvdisaster"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/dvdisaster.png
    done
  '';

  meta = with lib; {
    homepage = "https://dvdisaster.jcea.es/";
    description = "Data loss/scratch/aging protection for CD/DVD media";
    longDescription = ''
      Dvdisaster provides a margin of safety against data loss on CD and
      DVD media caused by scratches or aging media. It creates error correction
      data which is used to recover unreadable sectors if the disc becomes
      damaged at a later time.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "dvdisaster";
  };
}
