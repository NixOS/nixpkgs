{ lib, stdenv, fetchzip, openjdk, gradle, makeWrapper, maven }:

stdenv.mkDerivation rec {
  pname = "kotlin-language-server";
  version = "1.3.3";
  src = fetchzip {
    url = "https://github.com/fwcd/kotlin-language-server/releases/download/${version}/server.zip";
    hash = "sha256-m0AgPJ8KgzOxHPB33pgSFe7JQxidPkhDUga56LuaDBA=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp -r lib/* $out/lib
    cp -r bin/* $out/bin
  '';

  nativeBuildInputs = [ gradle makeWrapper ];
  buildInputs = [ openjdk gradle ];

  postFixup = ''
    wrapProgram "$out/bin/kotlin-language-server" --set JAVA_HOME ${openjdk} --prefix PATH : ${lib.strings.makeBinPath [ openjdk maven ] }
  '';

  meta = {
    description = "kotlin language server";
    longDescription = ''
      About Kotlin code completion, linting and more for any editor/IDE
      using the Language Server Protocol Topics'';
    maintainers = with lib.maintainers; [ vtuan10 ];
    homepage = "https://github.com/fwcd/kotlin-language-server";
    changelog = "https://github.com/fwcd/kotlin-language-server/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
