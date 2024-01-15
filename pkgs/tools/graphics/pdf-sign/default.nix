{ lib
, stdenv
, fetchFromGitHub

, python3
, ghostscript
, pdftk
, poppler_utils
, makeBinaryWrapper
}:

let
  python-env = python3.withPackages (ps: with ps; [ tkinter ]);
  binPath = lib.makeBinPath [ ghostscript pdftk poppler_utils ];
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp pdf-sign pdf-create-empty $out

    makeWrapper ${python-env}/bin/python $out/bin/pdf-sign \
          --add-flags $out/pdf-sign \
          --prefix PATH : ${binPath}
    makeWrapper ${python-env}/bin/python $out/bin/pdf-create-empty \
          --add-flags $out/pdf-create-empty \
          --prefix PATH : ${binPath}

    runHook postInstall
  '';

  meta = {
    description = "A tool to visually sign PDF files";
    homepage = "https://github.com/svenssonaxel/pdf-sign";
    license = lib.licenses.mit;
    mainProgram = "pdf-sign";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}

