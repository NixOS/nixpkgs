{ stdenv, fetchurl, pkgconfig, SDL2, alsaLib, gtk3, mesa_glu, makeWrapper
, mesa, libarchive, libao, unzip, xdg_utils, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  name = "nestopia-1.46.2";
  src = fetchurl {
    url = https://github.com/rdanbrook/nestopia/archive/1.46.2.tar.gz;
    sha256 = "07h49xwvg61dx20rk5p4r3ax2ar5y0ppvm60cqwqljyi9rdfbh7p";
  };

  # nondeterministic failures when creating directories
  enableParallelBuilding = false;

  hardeningDisable = [ "format" ];

  buildInputs = [ pkgconfig SDL2 alsaLib gtk3 mesa_glu mesa makeWrapper
                  libarchive libao unzip xdg_utils gsettings_desktop_schemas ];

  installPhase = ''
    mkdir -p $out/{bin,share/nestopia}
    make install PREFIX=$out
  '';

  preFixup = ''
     for f in $out/bin/*; do
       wrapProgram $f \
         --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
     done
  '';

  patches = [ ./build-fix.patch ];

  meta = {
    homepage = http://0ldsk00l.ca/nestopia/;
    description = "NES emulator with a focus on accuracy";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

