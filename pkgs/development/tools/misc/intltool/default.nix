{ stdenv, fetchurl, fetchpatch, gettext, perl, perlXMLParser }:

stdenv.mkDerivation rec {
  name = "intltool-${version}";
  version = "0.51.0";

  src = fetchurl {
    url = "https://launchpad.net/intltool/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1karx4sb7bnm2j67q0q74hspkfn6lqprpy5r99vkn5bb36a4viv7";
  };

  # fix "unescaped left brace" errors when using intltool in some cases
  patches = [(fetchpatch {
    name = "perl5.26-regex-fixes.patch";
    url = "https://sources.debian.org/data/main/i/intltool/0.51.0-5"
      + "/debian/patches/perl5.26-regex-fixes.patch";
    sha256 = "12q2140867r5d0dysly72khi7b0mm2gd7nlm1k81iyg7fxgnyz45";
  })];

  propagatedBuildInputs = [ gettext perl perlXMLParser ];

  meta = with stdenv.lib; {
    description = "Translation helper tool";
    homepage = https://launchpad.net/intltool/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
