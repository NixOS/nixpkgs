{ mkDerivation, lib, fetchFromGitHub, qtbase, cmake, qttools, qtsvg }:

mkDerivation rec {
  pname = "flameshot";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "0nr50ma8l612drl2br084kb3xac7jqkqr41b26d4p9y7ylwk05yq";
  };

  nativeBuildInputs = [ cmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://flameshot.js.org";
    maintainers = [ maintainers.scode ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
