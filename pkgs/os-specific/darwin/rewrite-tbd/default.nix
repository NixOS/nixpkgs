{ stdenv, lib, fetchFromGitHub, libyaml }:

stdenv.mkDerivation {
  pname = "rewrite-tbd";
  version = "unstable-2023-03-27";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "rewrite-tbd";
    rev = "d7852691762635028d237b7d00c3dc6a6613de79";
    hash = "sha256-syxioFiGvEv4Ypk5hlIjLQth5YmdFdr+NC+aXSXzG4k=";
  };

  # Nix takes care of these paths. Avoiding the use of `pkg-config` prevents an infinite recursion.
  postPatch = ''
    substituteInPlace Makefile.boot \
      --replace '$(shell pkg-config --cflags yaml-0.1)' "" \
      --replace '$(shell pkg-config --libs yaml-0.1)' "-lyaml"
  '';

  buildInputs = [ libyaml ];

  makeFlags = [ "-f" "Makefile.boot" "PREFIX=${placeholder "out"}"];

  meta = with lib; {
    homepage = "https://github.com/thefloweringash/rewrite-tbd/";
    description = "Rewrite filepath in .tbd to Nix applicable format";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
