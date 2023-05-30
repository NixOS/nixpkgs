{ lib
, fetchFromGitHub
, fetchpatch
, jre
, gradle_7
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

in
gradle.buildPackage {
  inherit pname src version patches;
  MA1SD_BUILD_VERSION = version;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];
  gradleOpts.depsHash = "sha256-Nsb2jnoSjSyrNQn9CrR1I9njguVeCluNspXch3bJ6eU=";
  gradleOpts.lockfile = ./gradle.lockfile;
  gradleOpts.buildscriptLockfile = ./buildscript-gradle.lockfile;

  # 30/126 tests currently fail
  doCheck = false;
  gradleOpts.flags = [ "-x" "test" ];

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
      binaryBytecode # deps
    ];
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };
}
