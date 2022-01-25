{ mkDerivation
, lib
, fetchFromGitHub
, qtbase
, cmake
, qttools
, qtsvg
, nix-update-script
}:

mkDerivation rec {
  pname = "flameshot";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "sha256-SlnEXW3Uhdgl0icwYyYsKQOcYkAtHpAvL6LMXBF2gWM=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ cmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    maintainers = with maintainers; [ scode oxalica ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
