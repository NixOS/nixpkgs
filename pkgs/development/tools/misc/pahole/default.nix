{ lib, stdenv, fetchgit, cmake, elfutils, zlib }:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.22";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git";
    rev = "v${version}";
    sha256 = "sha256-U1/i9WNlLphPIcNysC476sqil/q9tMYmu+Y6psga8I0=";
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
