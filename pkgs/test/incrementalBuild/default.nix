{ hello, incrementalBuildTools, runCommandNoCC, texinfo, stdenv, rsync }:
let
  baseHelloArtifacts = incrementalBuildTools.prepareIncrementalBuild hello;
  patchedHello = hello.overrideAttrs (old: {
    buildInputs = [ texinfo ];
    src = runCommandNoCC "patch-hello-src" { } ''
      mkdir -p $out
      cd $out
      tar xf ${hello.src} --strip-components=1
      patch -p1 < ${./hello.patch}
    '';
  });
  incrementalBuiltHello = incrementalBuildTools.mkIncrementalBuild patchedHello baseHelloArtifacts;

  incrementalBuiltHelloWithCheck = incrementalBuiltHello.overrideAttrs (old: {
    doCheck = true;
    checkPhase = ''
      echo "checking if unchanged source file is not recompiled"
        [ "$(stat --format="%Y" lib/exitfail.o)" = "$(stat --format="%Y" ${baseHelloArtifacts}/outputs/lib/exitfail.o)" ]
    '';
  });

  baseHelloRemoveFileArtifacts = incrementalBuildTools.prepareIncrementalBuild (hello.overrideAttrs (old: {
    patches = [ ./hello-additionalFile.patch ];
  }));

  preparedHelloRemoveFileSrc = runCommandNoCC "patch-hello-src" { } ''
    mkdir -p $out
    cd $out
    tar xf ${hello.src} --strip-components=1
    patch -p1 < ${./hello-additionalFile.patch}
  '';

  patchedHelloRemoveFile = hello.overrideAttrs (old: {
    buildInputs = [ texinfo ];
    src = runCommandNoCC "patch-hello-src" { } ''
      mkdir -p $out
      cd $out
      ${rsync}/bin/rsync -cutU --chown=$USER:$USER --chmod=+w -r ${preparedHelloRemoveFileSrc}/* .
      patch -p1 < ${./hello-removeFile.patch}
    '';
  });

  incrementalBuiltHelloWithRemovedFile = incrementalBuildTools.mkIncrementalBuild patchedHelloRemoveFile baseHelloRemoveFileArtifacts;
in
stdenv.mkDerivation {
  name = "patched-hello-returns-correct-output";
  buildCommand = ''
    touch $out

    echo "testing output of hello binary"
    [ "$(${incrementalBuiltHelloWithCheck}/bin/hello)" = "Hello, incremental world!" ]
    echo "testing output of hello with removed file"
    [ "$(${incrementalBuiltHelloWithRemovedFile}/bin/hello)" = "Hello, incremental world!" ]
  '';
}

