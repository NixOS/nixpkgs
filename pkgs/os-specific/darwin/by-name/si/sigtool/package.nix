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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "sigtool";
    rev = "v${version}";
    sha256 = "sha256-czprDpXy+wflnzqIeCIqxwPewYIYv8xlKzRp6eEhcqw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libplist
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Tool for working with embedded signatures in Mach-O files";
    homepage = "https://github.com/thefloweringash/sigtool";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "sigtool";
    maintainers = [ lib.maintainers.viraptor ];
  };
}
