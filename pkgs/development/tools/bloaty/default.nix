{ stdenv, binutils, fetchgit }:

stdenv.mkDerivation rec {
  version = "2016.11.16";
  name = "bloaty-${version}";

  src = fetchgit {
    url = "https://github.com/google/bloaty.git";
    rev = "d040e4821ace478f9b43360acd6801aefdd323f7";
    sha256 = "1qk2wgd7vzr5zy0332y9h69cwkqmy8x7qz97xpgwwnk54amm8i3k";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  configurePhase = ''
    sed -i 's,c++filt,${binutils}/bin/c++filt,' src/bloaty.cc
  '';

  installPhase = ''
    install -Dm755 {.,$out/bin}/bloaty
  '';

  meta = with stdenv.lib; {
    description = "a size profiler for binaries";
    homepage = https://github.com/google/bloaty;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.dtzWill ];
  };
}
