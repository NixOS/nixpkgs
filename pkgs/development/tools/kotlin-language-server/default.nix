{ lib, stdenv, fetchzip, openjdk11, gradle, makeWrapper, maven }:

stdenv.mkDerivation rec {
  pname = "kotlin-language-server";
  version = "1.3.1";
  src = fetchzip {
    url = "https://github.com/fwcd/kotlin-language-server/releases/download/${version}/server.zip";
    hash = "sha256-FxpNA4OGSgFdILl0yKBDTtVdQl6Bw9tm2eURbsJdZzI=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp -r lib/* $out/lib
    cp -r bin/* $out/bin
  '';

  nativeBuildInputs = [ gradle makeWrapper ];
  buildInputs = [ openjdk11 gradle ];

  postFixup = ''
    wrapProgram "$out/bin/kotlin-language-server" --set JAVA_HOME ${openjdk11} --prefix PATH : ${lib.strings.makeBinPath [ openjdk11 maven ] }
  '';

  meta = {
    description = "kotlin language server";
    longDescription = ''
      About Kotlin code completion, linting and more for any editor/IDE
      using the Language Server Protocol Topics'';
    maintainers = with lib.maintainers; [ vtuan10 ];
    homepage = "https://github.com/fwcd/kotlin-language-server";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
