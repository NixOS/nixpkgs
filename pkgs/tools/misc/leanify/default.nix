{ lib
, stdenv
, fetchFromGitHub
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "leanify";
  version = "unstable-2022-12-04";

  src = fetchFromGitHub {
    owner = "JayXon";
    repo = "Leanify";
    rev = "7847668ac5bf0df1d940b674bc8b907bd1b37044";
    hash = "sha256-KxVV7AW9sEfH4YTPDfeJk7fMMGh0eSkECXM/Mv9XqBA=";
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
  };
}
