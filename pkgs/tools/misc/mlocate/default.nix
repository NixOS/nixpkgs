{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mlocate-${version}";
  version = "0.26";

  src = fetchurl {
    url = "http://fedorahosted.org/releases/m/l/mlocate/${name}.tar.xz";
    sha256 = "0gi6y52gkakhhlnzy0p6izc36nqhyfx5830qirhvk3qrzrwxyqrh";
  };

  buildInputs = [ ];

  meta = with stdenv.lib; {
    description = "Merging locate is an utility to index and quickly search for files";
    homepage = https://fedorahosted.org/mlocate/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
