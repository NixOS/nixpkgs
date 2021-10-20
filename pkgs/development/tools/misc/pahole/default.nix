{ lib, stdenv, fetchgit, cmake, elfutils, zlib }:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.20";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git";
    rev = "v${version}";
    sha256 = "11q9dpfi4qj2v8z0nlf8c0079mlv10ljhh0d1yr0j4ds3saacd15";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ elfutils zlib ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [ "-D__LIB=lib" ];

  meta = with lib; {
    homepage = "https://git.kernel.org/cgit/devel/pahole/pahole.git/";
    description = "Pahole and other DWARF utils";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = [ maintainers.bosu ];
  };
}
