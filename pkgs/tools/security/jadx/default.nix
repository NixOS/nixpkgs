{ lib, fetchFromGitHub, gradle, jdk, makeWrapper }:

let
  pname = "jadx";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "skylot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3t2e3WfH/ohkdGWlfV3t9oHJ1Q6YM6nSLOgmzgJEkls=";
  };
in gradle.buildPackage {
  inherit pname version src;

  JADX_VERSION = version;

  gradleOpts = {
    buildSubcommand = "pack";
    depsHash = "sha256-PXDECswMhWc3nFXSfgcNymQgVLIxreshZ0ebmap+t00=";
    lockfileTree = ./lockfiles;
    depsAttrs.postInstall = ''
      # Work around okio-2.10.0 bug, fixed in 3.0. Remove "-jvm" from filename.
      # https://github.com/square/okio/issues/954
      mv $out/com/squareup/okio/okio/2.10.0/okio{-jvm,}-2.10.0.jar
    '';
  };

  nativeBuildInputs = [ gradle jdk makeWrapper ];

  # Otherwise, Gradle fails with `java.net.SocketException: Operation not permitted`
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    mkdir $out $out/bin
    cp -R build/jadx/lib $out
    for prog in jadx jadx-gui; do
      cp build/jadx/bin/$prog $out/bin
      wrapProgram $out/bin/$prog --set JAVA_HOME ${jdk.home}
    done
  '';

  meta = with lib; {
    description = "Dex to Java decompiler";
    longDescription = ''
      Command line and GUI tools for produce Java source code from Android Dex
      and Apk files.
    '';
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ delroth ];
  };
}
