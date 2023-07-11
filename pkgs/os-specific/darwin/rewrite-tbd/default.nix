{ stdenv, lib, fetchFromGitHub, libyaml }:

stdenv.mkDerivation {
  pname = "rewrite-tbd";
  version = "20201114";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "rewrite-tbd";
    rev = "988f29c6ccbca9b883966225263d8d78676da6a3";
    sha256 = "08sk91zwj6n9x2ymwid2k7y0rwv5b7p6h1b25ipx1dv0i43p6v1a";
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
    platforms = platforms.darwin;
    license = licenses.mit;
  };
}
