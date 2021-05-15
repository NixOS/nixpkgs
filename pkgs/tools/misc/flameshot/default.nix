{ mkDerivation, lib, fetchFromGitHub, qtbase, cmake, qttools, qtsvg }:

mkDerivation rec {
  pname = "flameshot";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "sha256-E5J61k1tVpbwlzYHbCY1rf9+GODcJRRAQwb0jR4s7BU=";
  };

  nativeBuildInputs = [ cmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    maintainers = [ maintainers.scode ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
