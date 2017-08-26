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
    name = "perl-5.22.patch";
    url = "https://anonscm.debian.org/viewvc/pkg-gnome/desktop/unstable/intltool"
      + "/debian/patches/perl5.22-regex-fixes?revision=47258&view=co&pathrev=47258";
    sha256 = "17clqczb9fky7hp8czxa0fy82b5478irvz4f3fnans3sqxl95hx3";
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
