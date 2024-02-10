{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, jre
, git
, gradle_7
, perl
, makeWrapper
}:

let
  pname = "ma1sd";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "ma1uta";
    repo = "ma1sd";
    rev = version;
    hash = "sha256-K3kaujAhWsRQuTMW3SZOnE7Rmu8+tDXaxpLrb45OI4A=";
  };

  gradle = gradle_7;

  patches = [
    # https://github.com/ma1uta/ma1sd/pull/122
    (fetchpatch {
      name = "java-16-compatibility.patch";
      url = "https://github.com/ma1uta/ma1sd/commit/be2e2e97ce21741ca6a2e29a06f5748f45dd414e.patch";
      hash = "sha256-dvCeK/0InNJtUG9CWrsg7BE0FGWtXuHo3TU0iFFUmIk=";
    })
  ];

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version patches;
    nativeBuildInputs = [ gradle perl git ];

    buildPhase = ''
      export MA1SD_BUILD_VERSION=${version}
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon build -x test
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    dontStrip = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Px8FLnREBC6pADcEPn/GfhrtGnmZqjXIX7l1xPjiCvQ=";
  };

in
stdenv.mkDerivation {
  inherit pname src version patches;
  nativeBuildInputs = [ gradle perl makeWrapper ];
  buildInputs = [ jre ];

  postPatch = ''
    substituteInPlace build.gradle \
      --replace 'gradlePluginPortal()' "" \
      --replace 'mavenCentral()' "mavenLocal(); maven { url '${deps}' }"
  '';

  buildPhase = ''
    runHook preBuild
    export MA1SD_BUILD_VERSION=${version}
    export GRADLE_USER_HOME=$(mktemp -d)

    gradle --offline --no-daemon build -x test
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D build/libs/source.jar $out/lib/ma1sd.jar
    makeWrapper ${jre}/bin/java $out/bin/ma1sd --add-flags "-jar $out/lib/ma1sd.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "a federated matrix identity server; fork of mxisd";
    homepage = "https://github.com/ma1uta/ma1sd";
    changelog = "https://github.com/ma1uta/ma1sd/releases/tag/${version}";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
    mainProgram = "ma1sd";
  };

}
