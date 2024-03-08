{ lib, stdenv, fetchFromGitHub, pkg-config, fuse, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "9pfs";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ftrvxmtrx";
    repo = "9pfs";
    rev = version;
    sha256 = "sha256-ywWG/H2ilt36mjlDSgIzYpardCFXpmbLiml6wy47XuA=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "pkg-config" "$PKG_CONFIG"
  '';

  makeFlags = [ "BIN=$(out)/bin" "MAN=$(out)/share/man/man1" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/ftrvxmtrx/9pfs";
    description = "FUSE-based client of the 9P network filesystem protocol";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.unix;
    license = with lib.licenses; [ lpl-102 bsd2 ];
  };
}
