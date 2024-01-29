{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, poppler
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "pdftoipe";
  version = "7.2.24.1";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe-tools";
    rev = "v${version}";
    hash = "sha256-jlrjrjzZQo79CKMySayhCm1dqLh89wOQuXrXa2aqc0k=";
  };

  patches = [
    # Fix build with poppler > 22.03.0
    # https://github.com/otfried/ipe-tools/pull/48
    (fetchpatch {
      url = "https://github.com/otfried/ipe-tools/commit/14335180432152ad094300d0afd00d8e390469b2.patch";
      hash = "sha256-V3FmwG3bR6io/smxjasFJ5K0/u8RSFfdUX41ClGXhFc=";
      stripLen = 1;
      name = "poppler_fix_build_48.patch";
    })
    # https://github.com/otfried/ipe-tools/pull/55
    (fetchpatch {
      url = "https://github.com/otfried/ipe-tools/commit/65586fcd9cc39e482ae5a9abdb6f4932d9bb88c4.patch";
      hash = "sha256-qr1AQyWHz1e2a65m05xSHFnP6oSP6qSmMVekNk2flRc=";
      stripLen = 1;
      name = "poppler_fix_build_55.patch";
    })
  ];

  sourceRoot = "${src.name}/pdftoipe";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler ];

  installPhase = ''
    install -D pdftoipe $out/bin/pdftoipe
  '';

  meta = with lib; {
    description = "A program that tries to convert arbitrary PDF documents to Ipe files";
    homepage = "https://github.com/otfried/ipe-tools";
    changelog = "https://github.com/otfried/ipe-tools/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yrd ];
    mainProgram = "pdftoipe";
  };
}
