{ stdenv, fetchgit, pkgs }:

stdenv.mkDerivation rec {
  version = "v0.3.2";
  name = "ecdsautils-${version}";

  src = fetchgit {
    url = "https://github.com/tcatm/ecdsautils.git";
    rev = "refs/tags/${version}";
    sha256 = "a1d14e4333a7bd13030c1fb36e462fa32afbf1765f976b913d0ca64432da2014";
  };

  buildInputs = [ pkgs.libuecc ];

  nativeBuildInputs = [ pkgs.cmake pkgs.pkgconfig pkgs.doxygen ];

  buildPhase = ''
    cmake -D CMAKE_BUILD_TYPE=RELEASE .
    make
  '';

  installPhase = ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Tiny collection of programs used for ECDSA (keygen, sign, verify)";
    license = stdenv.lib.licenses.bsd2;
    homepage = "https://github.com/tcatm/ecdsautils";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ maintainers.abaldeau ];
  };
}
