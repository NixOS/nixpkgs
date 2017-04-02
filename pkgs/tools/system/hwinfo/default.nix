{ stdenv, fetchFromGitHub, libx86emu, flex, perl }:

stdenv.mkDerivation rec {
  name = "hwinfo-${version}";
  version = "21.38";

  src = fetchFromGitHub {
    owner = "opensuse";
    repo = "hwinfo";
    rev = "${version}";
    sha256 = "17a1nx906gdl9br1wf6xmhjy195szaxxmyb119vayw4q112rjdql";
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
    maintainers = with maintainers; [ bobvanderlinden ndowens ];
    platforms = platforms.unix;
  };
}
