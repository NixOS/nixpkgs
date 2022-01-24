{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, poppler
}:

stdenv.mkDerivation rec {
  pname = "pdftoipe";
  version = "7.2.24.1";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe-tools";
    rev = "v${version}";
    sha256 = "jlrjrjzZQo79CKMySayhCm1dqLh89wOQuXrXa2aqc0k=";
  };
  sourceRoot = "source/pdftoipe";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler ];

  installPhase = ''
    install -D pdftoipe $out/bin/pdftoipe
  '';

  meta = with lib; {
    description = "A program that tries to convert arbitrary PDF documents to Ipe files";
    homepage = "https://github.com/otfried/ipe-tools";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yrd ];
  };
}
