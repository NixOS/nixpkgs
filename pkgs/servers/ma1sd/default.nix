{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, jre
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

in
stdenv.mkDerivation {
  inherit pname src version;

  patches = [
    # https://github.com/ma1uta/ma1sd/pull/122
    (fetchpatch {
      name = "java-16-compatibility.patch";
      url = "https://github.com/ma1uta/ma1sd/commit/be2e2e97ce21741ca6a2e29a06f5748f45dd414e.patch";
      hash = "sha256-dvCeK/0InNJtUG9CWrsg7BE0FGWtXuHo3TU0iFFUmIk=";
    })
  ];

  nativeBuildInputs = [ gradle perl makeWrapper ];
  buildInputs = [ jre ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  preBuild = ''
    export MA1SD_BUILD_VERSION=${version}
  '';

  gradleFlags = [ "-x" "test" ];

  installPhase = ''
    runHook preInstall
    install -D build/libs/source.jar $out/lib/ma1sd.jar
    makeWrapper ${jre}/bin/java $out/bin/ma1sd --add-flags "-jar $out/lib/ma1sd.jar"
    runHook postInstall
  '';

  passthru.updateDeps = gradle.updateDeps { inherit pname; };

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
