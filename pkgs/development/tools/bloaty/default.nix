{ stdenv, cmake, zlib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "bloaty-${version}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "v${version}";
    sha256 = "0fck83zyh9bwlwdk3fkhv3337g9nii6rzf96gyghmnrsp9rzxs3l";
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
