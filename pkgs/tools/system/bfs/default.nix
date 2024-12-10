{
  lib,
  stdenv,
  fetchFromGitHub,
  libcap,
  acl,
  oniguruma,
  liburing,
}:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "3.1.3";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    hash = "sha256-/thPPueNrYzbxxZYAqlxZ2GEsceCzd+LkI84S8AS1mo=";
  };

  buildInputs =
    [ oniguruma ]
    ++ lib.optionals stdenv.isLinux [
      libcap
      acl
      liburing
    ];

  # Disable LTO on darwin. See https://github.com/NixOS/nixpkgs/issues/19098
  preConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace GNUMakefile --replace "-flto=auto" ""
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
    maintainers = with maintainers; [
      yesbox
      cafkafk
    ];
    mainProgram = "bfs";
  };
}
