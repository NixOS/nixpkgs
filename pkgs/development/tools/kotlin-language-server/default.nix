{ lib, stdenv, fetchurl, unzip, openjdk11, gradle }:

stdenv.mkDerivation rec {
  pname = "kotlin-language-server";
  version = "1.3.0";
  src = fetchurl {
    url = "https://github.com/fwcd/kotlin-language-server/releases/download/${version}/server.zip";
    sha256 = "sha256-yyqI+87vtggSeAfb3OEftalknqbTDEQ5gTJwB/EMIlY=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp -r lib/* $out/lib
    cp -r bin/* $out/bin
  '';

  nativeBuildInputs = [ unzip gradle ];
  buildInputs = [ openjdk11 gradle ];

  meta = {
    description = "kotlin language server";
    longDescription = ''
      About Kotlin code completion, linting and more for any editor/IDE
      using the Language Server Protocol Topics'';
    homepage = "https://github.com/fwcd/kotlin-language-server";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
