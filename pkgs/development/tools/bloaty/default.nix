{ stdenv, binutils, fetchgit }:

stdenv.mkDerivation rec {
  version = "2016.12.28";
  name = "bloaty-${version}";

  src = fetchgit {
    url = "https://github.com/google/bloaty.git";
    rev = "2234386bcee7297dfa1b6d8a5d20f95ea4ed9bb0";
    sha256 = "0cfsjgbp9r16d6qi8v4k609bbhjff4vhdiapfkhr34z1cik1md4l";
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
