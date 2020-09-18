{ lib, stdenv, fetchFromGitHub, meson, ninja, pkgconfig, asciidoc
, jansson, jose, cryptsetup, curl, libpwquality, luksmeta
}:

stdenv.mkDerivation rec {
  pname = "clevis";
  version = "14";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j8id67jk3ikim2xh7vjg7j2ayrpm1a4n8v3n8r8pnr4rhqy76fd";
  };

  nativeBuildInputs = [ meson ninja pkgconfig asciidoc ];
  buildInputs = [ jansson jose cryptsetup curl libpwquality luksmeta ];

  outputs = [ "out" "man" ];

  meta = {
    description = "Automated Encryption Framework";
    homepage = "https://github.com/latchset/clevis";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
  };
}
