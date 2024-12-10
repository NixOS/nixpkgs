{
  lib,
  stdenv,
  fetchFromGitHub,
  zsh,
}:

stdenv.mkDerivation rec {
  pname = "zthrottle";
  version = "unstable-2017-7-24";

  src = fetchFromGitHub {
    owner = "anko";
    repo = pname;
    rev = "f62066661e49375baeb891fa8e43ad4527cbd0a0";
    sha256 = "1ipvwmcsigzmxlg7j22cxpvdcgqckkmfpsnvzy18nbybd5ars9l5";
  };

  buildInputs = [ zsh ];

  installPhase = ''
    install -D zthrottle $out/bin/zthrottle
  '';

  meta = with lib; {
    description = "A program that throttles a pipeline, only letting a line through at most every $1 seconds";
    homepage = "https://github.com/anko/zthrottle";
    license = licenses.unlicense;
    maintainers = [ maintainers.ckie ];
    platforms = platforms.unix;
    mainProgram = "zthrottle";
  };
}
