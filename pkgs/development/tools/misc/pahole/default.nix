{ stdenv, fetchgit, cmake, elfutils, zlib }:

stdenv.mkDerivation rec {
  name = "pahole-${version}";
  version = "1.12";
  src = fetchgit {
    url = https://git.kernel.org/pub/scm/devel/pahole/pahole.git;
    sha256 = "1a8xfwqdc2j3ydh9bk2pkvsaf3lrkbxj66vj991c7knc31ix8kpw";
    rev = "v${version}";
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
