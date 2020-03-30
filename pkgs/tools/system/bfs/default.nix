{ stdenv, fetchFromGitHub, libcap, acl }:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "1.6";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    sha256 = "0qrxd1vdz2crk7jf7cdda5bhm1f841hjvin7fn497wymwr5qyjah";
  };

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ libcap acl ];

  # Disable LTO on darwin. See https://github.com/NixOS/nixpkgs/issues/19098
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "-flto -DNDEBUG" "-DNDEBUG"
  '';

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "release" ]; # "release" enables compiler optimizations

  meta = with stdenv.lib; {
    description = "A breadth-first version of the UNIX find command";
    longDescription = ''
      bfs is a variant of the UNIX find command that operates breadth-first rather than
      depth-first. It is otherwise intended to be compatible with many versions of find.
    '';
    homepage = "https://github.com/tavianator/bfs";
    license = licenses.bsd0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yesbox ];
  };
}
