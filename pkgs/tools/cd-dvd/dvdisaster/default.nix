{ stdenv, fetchurl, pkgconfig, gettext, which
, glib, gtk2
, enableSoftening ? true
}:

stdenv.mkDerivation rec {
  name = "dvdisaster-${version}";
  version = "0.79.5";

  src = fetchurl {
    url = "http://dvdisaster.net/downloads/${name}.tar.bz2";
    sha256 = "0f8gjnia2fxcbmhl8b3qkr5b7idl8m855dw7xw2fnmbqwvcm6k4w";
  };

  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [ gettext pkgconfig which ];
  buildInputs = [ glib gtk2 ];

  patches = stdenv.lib.optional enableSoftening [
    ./encryption.patch
    ./dvdrom.patch
  ];

  postPatch = ''
    patchShebangs ./
    sed -i 's/dvdisaster48.png/dvdisaster/' contrib/dvdisaster.desktop
  '';

  configureFlags = [
    # Explicit --docdir= is required for on-line help to work:
    "--docdir=$out/share/doc"
    "--with-nls=yes"
    "--with-embedded-src-path=no"
  ] ++ stdenv.lib.optional (builtins.elem stdenv.system
      stdenv.lib.platforms.x86_64) "--with-sse2=yes";

  # fatal error: inlined-icons.h: No such file or directory
  enableParallelBuilding = false;

  doCheck = true;
  checkPhase = ''
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
  '';

  postInstall = ''
    mkdir -pv $out/share/applications
    cp contrib/dvdisaster.desktop $out/share/applications/

    for size in 16 24 32 48 64; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps/
      cp contrib/dvdisaster"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/dvdisaster.png
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://dvdisaster.net/;
    description = "Data loss/scratch/aging protection for CD/DVD media";
    longDescription = ''
      Dvdisaster provides a margin of safety against data loss on CD and
      DVD media caused by scratches or aging media. It creates error correction
      data which is used to recover unreadable sectors if the disc becomes
      damaged at a later time.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds nckx ];
  };
}
