{ lib, stdenv, fetchurl, SDL, SDL_image, SDL_ttf, SDL_mixer, libpng,
  cairo, librsvg, gettext, libpaper, fribidi, pkg-config, gperf, imagemagick }:

stdenv.mkDerivation rec {
  version = "0.9.24";
  pname = "tuxpaint";

  src = fetchurl {
    url = "mirror://sourceforge/tuxpaint/${version}/${pname}-${version}.tar.gz";
    sha256 = "06m1lg2pikfkmassfvvrbwqffwgixcmjh1li6akaldgkalpmfql7";
  };

  nativeBuildInputs = [ SDL SDL_image SDL_ttf SDL_mixer libpng cairo
    librsvg gettext libpaper fribidi pkg-config gperf imagemagick ];
  hardeningDisable = [ "format" ];
  makeFlags = [ "GPERF=${gperf}/bin/gperf"
                "PREFIX=$$out"
                "COMPLETIONDIR=$$out/share/bash-completion/completions"
              ];

  patches = [ ./tuxpaint-completion.diff ];
  postPatch = ''
    grep -Zlr include.*SDL . | xargs -0 sed -i -e 's,"SDL,"SDL/SDL,'
  '';

  # stamps
  stamps = fetchurl {
    url = "mirror://sourceforge/project/tuxpaint/tuxpaint-stamps/2014-08-23/tuxpaint-stamps-2014.08.23.tar.gz";
    sha256 = "0rhlwrjz44wp269v3rid4p8pi0i615pzifm1ym6va64gn1bms06q";
  };

  postInstall = ''
    # Install desktop file
    mkdir -p $out/share/applications
    cp hildon/tuxpaint.xpm $out/share/pixmaps
    sed -e "s+Exec=tuxpaint+Exec=$out/bin/tuxpaint+" < src/tuxpaint.desktop > $out/share/applications/tuxpaint.desktop

    # Install stamps
    tar xzf $stamps
    cd tuxpaint-stamps-2014.08.23
    make install-all PREFIX=$out
    rm -rf $out/share/tuxpaint/stamps/military
  '';

  meta = {
    description = "Open Source Drawing Software for Children";
    homepage = "http://www.tuxpaint.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
