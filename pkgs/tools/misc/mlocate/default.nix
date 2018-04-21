{ stdenv, fetchurl, config }:

let
  dbfile = stdenv.lib.attrByPath [ "locate" "dbfile" ] "/var/cache/locatedb" config;
in stdenv.mkDerivation rec {
  name = "mlocate-${version}";
  version = "0.26";

  src = fetchurl {
    url = "https://releases.pagure.org/mlocate/${name}.tar.xz";
    sha256 = "0gi6y52gkakhhlnzy0p6izc36nqhyfx5830qirhvk3qrzrwxyqrh";
  };

  buildInputs = [ ];
  makeFlags = [ "dbfile=${dbfile}" ];

  meta = with stdenv.lib; {
    description = "Merging locate is an utility to index and quickly search for files";
    homepage = https://pagure.io/mlocate;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
