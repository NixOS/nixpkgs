{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libplist,
}:

stdenv.mkDerivation rec {
  pname = "sigtool";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "sigtool";
    rev = "v${version}";
    sha256 = "sha256-bybUgdGArOPkhjIby58TGtwv1kOGgWi9MEL+Bb7SV8A=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libplist
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Tool for working with embedded signatures in Mach-O files";
    homepage = "https://github.com/nix-community/sigtool";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "sigtool";
    maintainers = [ lib.maintainers.viraptor ];
  };
}
