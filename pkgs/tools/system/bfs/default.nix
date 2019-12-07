{ stdenv, fetchFromGitHub, libcap, acl }:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "1.5.1";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    sha256 = "1yp8zaj2rqd1df20wxym1x7q5d3lxqwalazbvmfnwqn5y4m368y3";
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
    homepage = https://github.com/tavianator/bfs;
    license = licenses.bsd0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yesbox ];
  };
}
