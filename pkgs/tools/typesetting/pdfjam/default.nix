{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "pdfjam-1.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.warwick.ac.uk/go/pdfjam/pdfjam_1.20.tgz;
    sha256 = "05g3mx7mb6h15ivbv0f53r369xphy8ad8a2xblpnk9mrnlrkaxy9";
  };
  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = maintainers.mornfall;
  };
}
