{ lib
, stdenv
, fetchFromGitHub
, substituteAll

, python3
, ghostscript
, coreutils
, pdftk
, poppler_utils
}:

let
  python-env = python3.withPackages (ps: with ps; [ tkinter ]);
in
stdenv.mkDerivation {
  pname = "pdf-sign";
  version = "unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "svenssonaxel";
    repo = "pdf-sign";
    rev = "98742c6b12ebe2ca3ba375c695f43b52fe38b362";
    hash = "sha256-5GRk0T1iLqmvWI8zvZE3OWEHPS0/zN/Ie9brjZiFpqc=";
  };

  patches = [
    (substituteAll {
      src = ./use-nix-paths.patch;
      gs = "${ghostscript}/bin/gs";
      mv = "${coreutils}/bin/mv";
      pdftk = "${pdftk}/bin/pdftk";
      pdfinfo = "${poppler_utils}/bin/pdfinfo";
    })
  ];

  buildInputs = [ python-env ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp pdf-sign pdf-create-empty $out/bin
    patchShebangs $out/bin

    runHook postInstall
  '';

  meta = {
    description = "A tool to visually sign PDF files";
    homepage = "https://github.com/svenssonaxel/pdf-sign";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}

