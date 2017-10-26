{ stdenv, binutils, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2017-10-05";
  name = "bloaty-${version}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "e47b21b01ceecf001e1965e9da249d48d86a1749";
    sha256 = "1il3z49hi0b07agjwr5fg1wzysfxsamfv1snvlp33vrlyl1m7cbm";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace src/bloaty.cc \
      --replace "c++filt" \
                "${stdenv.lib.getBin binutils}/bin/c++filt"
  '';

  doCheck = true;

  checkPhase = "ctest";

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
