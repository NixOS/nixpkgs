{ lib
, stdenv
, fetchFromGitHub
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "leanify";
  version = "unstable-2023-10-19";

  src = fetchFromGitHub {
    owner = "JayXon";
    repo = "Leanify";
    rev = "5511415b02a7669f5fe9b454e5705e8328ab0359";
    hash = "sha256-eOp/SOynh0HUz62Ki5ADRk7FjQY0Gh55ydVnO0MCXAA=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace "-flto" "" \
      --replace "lib/LZMA/Alloc.o" "lib/LZMA/CpuArch.o lib/LZMA/Alloc.o"
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp leanify $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight lossless file minifier/optimizer";
    longDescription = ''
      Leanify is a lightweight lossless file minifier/optimizer.
      It removes unnecessary data (debug information, comments, metadata, etc.) and recompress the file to reduce file size.
      It will not reduce image quality at all.
    '';
    homepage = "https://github.com/JayXon/Leanify";
    changelog = "https://github.com/JayXon/Leanify/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.mynacol ];
    platforms = platforms.all;
    mainProgram = "leanify";
  };
}
