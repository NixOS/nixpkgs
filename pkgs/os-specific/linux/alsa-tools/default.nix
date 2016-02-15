{ stdenv, fetchurl, alsaLib, pkgconfig, gtk, gtk3, fltk13 }:

stdenv.mkDerivation rec {
  name = "alsa-tools-${version}";
  version = "1.1.0";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/tools/${name}.tar.bz2"
      "http://alsa.cybermirror.org/tools/${name}.tar.bz2"
    ];
    sha256 = "3b1c3135b76e14532d3dd23fb15759ddd7daf9ffbc183f7a9a0a3a86374748f1";
  };

  buildInputs = [ alsaLib pkgconfig gtk gtk3 fltk13 ];

  patchPhase = ''
    export tools="as10k1 hda-verb hdspmixer echomixer hdajackretask hdspconf hwmixvolume mixartloader rmedigicontrol sscape_ctl vxloader envy24control hdajacksensetest hdsploader ld10k1 pcxhrloader sb16_csp us428control"
    # export tools="as10k1 hda-verb hdspmixer qlo10k1 seq usx2yloader echomixer hdajackretask hdspconf hwmixvolume mixartloader rmedigicontrol sscape_ctl vxloader envy24control hdajacksensetest hdsploader ld10k1 pcxhrloader sb16_csp us428control"
  '';

  configurePhase = ''
    for tool in $tools; do
      echo "Tool: $tool:"
      cd "$tool"; ./configure --prefix="$out"; cd -
    done
  '';

  buildPhase = ''
    for tool in $tools; do
      cd "$tool"; make; cd -
    done
  '';

  installPhase = ''
    for tool in $tools; do
      cd "$tool"; make install; cd -
    done
  '';

  meta = {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture tools";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.fps ];
  };
}
