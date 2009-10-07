{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "p7zip-9.04";
  
  src = fetchurl {
    url = mirror://sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2;
    sha256 = "1azr73vlj602hl6siagnqd1rn8sw73lny292jqgspg0lb9wvdyyx";
  };
  
  preConfigure =
    ''
      makeFlagsArray=(DEST_HOME=$out)
    '';

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
    # license = "LGPLv2.1+"; + "unRAR restriction"
    platforms = [ stdenv.lib.platforms.unix ];
  };
}
