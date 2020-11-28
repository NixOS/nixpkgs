{ lib, stdenv, fetchFromGitHub, meson, ninja, pkgconfig, asciidoc
, jansson, jose, cryptsetup, curl, libpwquality, luksmeta
}:

stdenv.mkDerivation rec {
  pname = "clevis";
  version = "15";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wfgd2v1r47ckh5qp60b903191fx0fa27zyadxlsb8riqszhmwvz";
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
