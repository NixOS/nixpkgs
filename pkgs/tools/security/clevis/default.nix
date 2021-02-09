{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, asciidoc
, jansson, jose, cryptsetup, curl, libpwquality, luksmeta
}:

stdenv.mkDerivation rec {
  pname = "clevis";
  version = "16";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DWrxk+Nb2ptF5nCaXYvRY8hAFa/n+6OGdKWO+Sq61yk=";
  };

  nativeBuildInputs = [ meson ninja pkg-config asciidoc ];
  buildInputs = [ jansson jose cryptsetup curl libpwquality luksmeta ];

  outputs = [ "out" "man" ];

  meta = {
    description = "Automated Encryption Framework";
    homepage = "https://github.com/latchset/clevis";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
  };
}
