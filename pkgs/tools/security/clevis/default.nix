{ lib, stdenv, fetchFromGitHub, meson, ninja, pkgconfig, asciidoc
, jansson, jose, cryptsetup, curl, libpwquality, luksmeta
}:

stdenv.mkDerivation rec {
  pname = "clevis";
  version = "12";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dbyl3c21h841w9lrrq6gd5y6dhamr0z5ixd87jz86cn02lznp5m";
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
