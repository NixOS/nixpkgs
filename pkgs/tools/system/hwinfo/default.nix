{ stdenv, fetchurl, libx86emu, flex, perl }:

stdenv.mkDerivation rec {
  name = "hwinfo-${version}";
  version = "21.23";

  src = fetchurl {
    url = "https://github.com/opensuse/hwinfo/archive/${version}.tar.gz";
    sha256 = "1a8815zp3a7n2jx0cn0hcr69rfr6vmw8r8grbn5mv61g90bbcj6p";
  };

  patchPhase = ''
    # VERSION and changelog is usually generated using Git
    echo "${version}" > VERSION
    sed -i 's|^\(TARGETS\s*=.*\)\<changelog\>\(.*\)$|\1\2|g' Makefile

    sed -i 's|lex isdn_cdb.lex|${flex}/bin/flex isdn_cdb.lex|g' src/isdn/cdb/Makefile
    sed -i 's|/sbin|/bin|g' Makefile
    sed -i 's|/usr/|/|g' Makefile
  '';

  installPhase = ''
    make install DESTDIR=$out
  '';

  buildInputs = [ libx86emu flex perl ];

  meta = with stdenv.lib; {
    description = "Hardware detection tool from openSUSE";
    license = licenses.gpl2;
    homepage = https://github.com/openSUSE/hwinfo;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.unix;
  };
}
