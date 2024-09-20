{ lib
, stdenv
, fetchFromGitHub
, writeShellScript
, texliveBasic
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

  nativeBuildInputs = [
    texliveBasic
    # multiple-outputs.sh fails if $out is not defined
    (writeShellScript "force-tex-output.sh" ''
      out="''${tex-}"
    '')
  ];

  buildPhase = ''
    make sagetex.sty
  '';

  installPhase = ''
    path="$out/tex/latex/sagetex"
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
