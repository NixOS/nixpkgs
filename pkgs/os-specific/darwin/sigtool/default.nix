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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Tool for working with embedded signatures in Mach-O files";
    homepage = "https://github.com/thefloweringash/sigtool";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool for working with embedded signatures in Mach-O files";
    homepage = "https://github.com/thefloweringash/sigtool";
    license = licenses.mit;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
