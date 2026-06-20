{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "sigtool";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "sigtool";
    rev = "v${version}";
    sha256 = "sha256-K3VSFaqcZEomF7kROJz+AwxdW1MmxxEFDaRnWnzcw54=";
  };

  patches = [
    # Fix missing `UINT64_C` when building with GCC on Linux
    ./0001-fix-build-with-gcc.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Tool for working with embedded signatures in Mach-O files";
    homepage = "https://github.com/thefloweringash/sigtool";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "sigtool";
  };
}
