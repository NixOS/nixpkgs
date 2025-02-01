{ lib, stdenv, fetchFromGitHub, libcap, acl, oniguruma, liburing }:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "4.0.2";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    hash = "sha256-WIJyCpnlD6/c7PG+ZPmUT8qfPelRY9Od1Dk9Ro1y1yY=";
  };

  buildInputs = [ oniguruma ] ++ lib.optionals stdenv.isLinux [ libcap acl liburing ];

  configureFlags = [ "--enable-release" ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Breadth-first version of the UNIX find command";
    longDescription = ''
      bfs is a variant of the UNIX find command that operates breadth-first rather than
      depth-first. It is otherwise intended to be compatible with many versions of find.
    '';
    homepage = "https://github.com/tavianator/bfs";
    license = licenses.bsd0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yesbox cafkafk ];
    mainProgram = "bfs";
  };
}
