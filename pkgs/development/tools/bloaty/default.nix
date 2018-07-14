{ stdenv, binutils, cmake, zlib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2018-06-15";
  name = "bloaty-${version}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "bdbb3ce196c86d2154f5fba99b5ff73ca43446a9";
    sha256 = "1r7di2p8bi12jpgl6cm4ygi1s0chv767mdcavc7pb45874vl02fx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  enableParallelBuilding = true;

  doCheck = true;

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
