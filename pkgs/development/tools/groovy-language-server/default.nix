{ lib
, stdenv
, fetchFromGitHub
, gradle_6
, perl
, makeWrapper
, openjdk17_headless
}:
let
  pname = "groovy-language-server";
  version = "unstable-2023-03-20";

  gradle = gradle_6;

  src = fetchFromGitHub {
    owner = "GroovyLanguageServer";
    repo = "groovy-language-server";
    rev = "4866a3f2c180f628405b1e4efbde0949a1418c10";
    hash = "sha256-LXCdF/cUYWy7mD3howFXexG0+fGfwFyKViuv9xZfgXc=";
  };

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    buildInputs = [ gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-kYuT3dIhoIrUD8RJK1ubuSLpegA7q4UzsgF9H2xdRnk=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ gradle makeWrapper ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)

    substituteInPlace build.gradle \
      --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }'
    echo "pluginManagement { repositories { maven { url '${deps}' } } }" > settings.gradle

    gradle --offline --no-daemon build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/libs/source-all.jar -t $out/lib
    makeWrapper "${openjdk17_headless}/bin/java" "$out/bin/groovy-language-server" \
      --add-flags "-jar $out/lib/source-all.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A language server for Groovy";
    homepage = "https://github.com/GroovyLanguageServer/groovy-language-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ traxys ];
  };
}
