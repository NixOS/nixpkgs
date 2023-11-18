{ lib, stdenv, cmake, zlib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bloaty";
  version = "1.1-unstable-2023-11-06";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    # no version since 1.1 in 2020
    rev = "16f9fe54d9cd0e9abe1d25fc1a9b44c214cfaa9f";
    hash = "sha256-w855aSLzzvuUWjAU9zOKuZTNGLZiEKMJYjVGejH48xQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  doCheck = true;

  installPhase = ''
    install -Dm755 {.,$out/bin}/bloaty
  '';

  meta = with lib; {
    description = "a size profiler for binaries";
    homepage = "https://github.com/google/bloaty";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dtzWill ];
  };
}
