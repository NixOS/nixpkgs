{ lib
, stdenv
, fetchFromGitHub
, swift
, swiftpm
, Compression
}:
stdenv.mkDerivation rec {
  pname = "unxip";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "saagarjha";
    repo = "unxip";
    rev = "v${version}";
    hash = "sha256-dEeHRLKsCJrviFsT+KawIvp3L4SE2gCiwtOQ7I/VTCA=";
  };

  nativeBuildInputs = [ swift swiftpm ];
  buildInputs = [ Compression ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/unxip $out/bin/
  '';

  meta = {
    description = "A fast Xcode unarchiver";
    homepage = "https://github.com/saagarjha/unxip";
    platforms = lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stephank ];
  };
}
