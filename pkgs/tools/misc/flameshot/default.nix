{ mkDerivation, lib, fetchFromGitHub, qtbase, cmake, qttools, qtsvg }:

mkDerivation rec {
  pname = "flameshot";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "1z77igs60lz106vsf6wsayxjafxm3llf2lm4dpvsqyyrxybfq191";
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
