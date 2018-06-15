{ stdenv, binutils, cmake, zlib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2018-05-22";
  name = "bloaty-${version}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "054788b091ccfd43b05b9817062139145096d440";
    sha256 = "0pmv66137ipzsjjdz004n61pz3aipjhh3b0w0y1406clqpwkvpjm";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  enableParallelBuilding = true;

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
