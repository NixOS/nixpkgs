{ lib, stdenv, fetchFromGitHub, libcap, acl, oniguruma }:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "3.0.1";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    sha256 = "sha256-/CiQUK6nmu3MtkG5PMQPn05qIO/M0Oy/LdBI/8oFdqA=";
  };

  buildInputs = [ oniguruma ] ++ lib.optionals stdenv.isLinux [ libcap acl ];

  # Disable LTO on darwin. See https://github.com/NixOS/nixpkgs/issues/19098
  preConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "-flto" ""
  '';

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "release" ]; # "release" enables compiler optimizations

  meta = with lib; {
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
