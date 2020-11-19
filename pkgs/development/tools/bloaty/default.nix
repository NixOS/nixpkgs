{ stdenv, cmake, zlib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1";
  pname = "bloaty";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "v${version}";
    sha256 = "1556gb8gb8jwf5mwxppcqz3mp269b5jhd51kj341iqkbn27zzngk";
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
    homepage = "https://github.com/google/bloaty";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dtzWill ];
  };
}
