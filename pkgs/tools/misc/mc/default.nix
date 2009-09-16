{ stdenv, fetchurl, lib, pkgconfig, glib, ncurses, e2fsprogs, gpm
, libX11, libXt, shebangfix, perl, zip, unzip, gettext, slang}:

stdenv.mkDerivation rec {
  name = "mc-4.6.1";
  src = fetchurl {
    url = "http://www.ibiblio.org/pub/Linux/utils/file/managers/mc/${name}.tar.gz";
    sha256 = "0zly25mwdn84s0wqx9mzyqi177mm828716nv1n6a4a5cm8yv0sh8";
  };
  buildInputs = [pkgconfig glib ncurses libX11 libXt
                 shebangfix perl zip unzip slang gettext e2fsprogs gpm];
  
  # Fix the paths to the terminfo files. Otherwise mc has no colors
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses}/lib/terminfo|" configure
  '';
  configureFlags = "--enable-charset";
  
  # Stole some patches from LFS which fix some nasty bugs
  patches = [ ./mc-4.6.1-bash32-1.patch ./mc-4.6.1-debian_fixes-1.patch ];
  
  # Required to enable the Debian UTF8 fixes
  CPPFLAGS = "-DUTF8";
  
  # The Debian UTF8 patch expects that the documentation is in UTF8 format,
  # therefore we have to convert them (I stole this also from LFS)
  
  postBuildPhase = ''
    for file in lib/mc.hint{,.es,.it,.nl} doc/{es,it}/mc.hlp.*
    do
        iconv -f ISO-8859-1 -t UTF-8 $file > $file.utf8 &&
        mv $file.utf8 $file
    done &&
    for file in lib/mc.hint{.cs,.hu,.pl} doc/{hu,pl}/mc.hlp.*
    do
        iconv -f ISO-8859-2 -t UTF-8 $file > $file.utf8 &&
        mv $file.utf8 $file
    done &&
    for file in lib/mc.hint.sr doc/sr/mc.hlp.sr
    do
        iconv -f ISO-8859-5 -t UTF-8 $file > $file.utf8 &&
        mv $file.utf8 $file
    done &&
    for file in doc/ru/mc.hlp.ru lib/mc.hint.ru
    do
        iconv -f KOI8-R -t UTF-8 $file > $file.utf8 &&
        mv $file.utf8 $file
    done &&

    iconv -f KOI8-U -t UTF-8 lib/mc.hint.uk > lib/mc.hint.uk.utf8 &&
    mv lib/mc.hint.uk.utf8 lib/mc.hint.uk &&
    iconv -f BIG5 -t UTF-8 lib/mc.hint.zh > lib/mc.hint.zh.utf8 &&
    mv lib/mc.hint.zh.utf8 lib/mc.hint.zh
    # foo
  '';
  
  makeFlags = "UNZIP=unzip";
  postInstall = ''
    find $out -iname "*.pl" | xargs shebangfix;
  '';
  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.ibiblio.org/mc;
    maintainers = [ lib.maintainers.sander ];
  };
}
