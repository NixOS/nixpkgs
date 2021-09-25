{ lib, stdenv, fetchFromGitHub, pkg-config, fuse3, fuse, pcre }:

stdenv.mkDerivation {
  pname = "rewritefs";
  version = "2020-02-21";

  src = fetchFromGitHub {
    owner  = "sloonz";
    repo   = "rewritefs";
    rev    = "bc241c7f81e626766786b56cf71d32c1a6ad510c";
    sha256 = "0zj2560hcbg5az0r8apnv0zz9b22i9r9w6rlih0rbrn673xp7q2i";
  };

  nativeBuildInputs = [ pkg-config ];
  # Note: fuse is needed solely because (unlike fuse3) it exports ulockmgr.h.
  # This library was removed in fuse 3 to be distributed separately, but
  # apparently it's not.
  buildInputs = [ fuse3 fuse pcre ];

  prePatch = ''
    # do not set sticky bit in nix store
    substituteInPlace Makefile --replace 6755 0755
  '';

  preConfigure = "substituteInPlace Makefile --replace /usr/local $out";

  meta = with lib; {
    description = ''A FUSE filesystem intended to be used
      like Apache mod_rewrite'';
    homepage    = "https://github.com/sloonz/rewritefs";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
