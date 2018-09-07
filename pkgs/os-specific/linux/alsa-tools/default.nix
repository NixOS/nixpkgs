{ stdenv, fetchurl, alsaLib, pkgconfig, gtk2, gtk3, fltk13 }:
# Comes from upstream as as bundle of several tools,
# some use gtk2, some gtk3 (and some even fltk13).

stdenv.mkDerivation rec {
  name = "alsa-tools-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://alsa/tools/${name}.tar.bz2";
    sha256 = "09rjb6hw1mn9y1jfdfj5djncgc2cr5wfps83k56rf6k4zg14v76n";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib gtk2 gtk3 fltk13 ];

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

  meta = with stdenv.lib; {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture tools";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.fps ];
  };
}
