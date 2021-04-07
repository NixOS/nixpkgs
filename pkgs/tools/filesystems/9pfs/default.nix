{ lib, stdenv, fetchFromGitHub, fuse }:

stdenv.mkDerivation {
  name = "9pfs-20150918";

  src = fetchFromGitHub {
    owner = "mischief";
    repo = "9pfs";
    rev = "7f4ca4cd750d650c1215b92ac3cc2a28041960e4";
    sha256 = "007s2idsn6bspmfxv1qabj39ggkgvn6gwdbhczwn04lb4c6gh3xc";
  };

  preConfigure =
    ''
      substituteInPlace Makefile --replace '-g bin' ""
      installFlagsArray+=(BIN=$out/bin MAN=$out/share/man/man1)
      mkdir -p $out/bin $out/share/man/man1
    '';

  buildInputs = [ fuse ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/mischief/9pfs";
    description = "FUSE-based client of the 9P network filesystem protocol";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ lpl-102 bsd2 ];
  };
}
