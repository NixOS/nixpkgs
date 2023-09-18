{ lib, stdenv, fetchFromGitHub, libcap, acl, oniguruma }:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "3.0.2";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    sha256 = "sha256-sE8VzLM2e1xUMU7nfU4JYIU5dZhuRwpE1OE+z5M+U0U=";
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
