{ stdenv, fetchgit, cmake, elfutils, zlib }:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.15";
  src = fetchgit {
    url = https://git.kernel.org/pub/scm/devel/pahole/pahole.git;
    rev = "v${version}";
    sha256 = "10af9mh3qxbx0hgjcmh0vjbg22bgxzhbpd9395ymasyw4npg6l9x";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ elfutils zlib ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [ "-D__LIB=lib" ];

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/cgit/devel/pahole/pahole.git/;
    description = "Pahole and other DWARF utils";
    license = licenses.gpl2;

    platforms = platforms.linux;
    maintainers = [ maintainers.bosu ];
  };
}
