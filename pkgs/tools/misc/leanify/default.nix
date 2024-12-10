{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "leanify";
  version = "unstable-2023-12-17";

  src = fetchFromGitHub {
    owner = "JayXon";
    repo = "Leanify";
    rev = "9daa4303cdc03f6b90b72c369e6377c6beb75c39";
    hash = "sha256-fLazKCQnOT3bN3Kz25Q80RLk54EU5U6HCf6kPLcXn9c=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail "-flto" "" \
      --replace-fail "lib/LZMA/Alloc.o" "lib/LZMA/CpuArch.o lib/LZMA/Alloc.o" \
      --replace-quiet "-Werror" ""
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
