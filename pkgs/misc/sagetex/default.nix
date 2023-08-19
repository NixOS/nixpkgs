{ lib
, stdenv
, fetchFromGitHub
, writeScript
, texlive
}:

stdenv.mkDerivation rec {
  pname = "sagetex";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sagetex";
    rev = "v${version}";
    sha256 = "sha256-OfhbXHbGI+DaDHqZCOGiSHJPHjGuT7ZqSEjKweloW38=";
  };

  outputs = [ "tex" ];

  # multiple-outputs.sh fails when $out is not defined
  nativeBuildInputs = [
    (writeScript "force-tex-output.sh" ''
      export out="$tex"
    '')
  ];

  buildInputs = [
    texlive.combined.scheme-basic
  ];

  buildPhase = ''
    make sagetex.sty
  '';

  installPhase = ''
    path="$tex/tex/latex/sagetex"
    mkdir -p "$path"
    cp -va *.sty *.cfg *.def "$path/"
  '';

  meta = with lib; {
    description = "Embed code, results of computations, and plots from Sage into LaTeX documents";
    homepage = "https://github.com/sagemath/sagetex";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexnortung ];
    platforms = platforms.all;
  };
}
