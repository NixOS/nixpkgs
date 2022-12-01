{ stdenv
, coursier
, fetchurl
, autoPatchelfHook
, installShellFiles
, jre
, lib
, buildGraalvmNativeImage
  # it's be nice to get rid of this directly here
, graalvm11-ce
}:

let
  version = "1.5.4";
  deps = stdenv.mkDerivation {
    name = "bloop-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch ch.epfl.scala:bloopgun_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-yer4ys31/1AhwbXU6j4yDaTv61QIwvtagTIVYhxGWRo=";
  };

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = "sha256-2mt+zUEJvQ/5ixxFLZ3Z0m7uDSj/YE9sg/uNMjamvdE=";
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = "sha256-eFESR6iPHRDViGv+Fk3sCvPgVAhk2L1gCG4LnfXO/v4=";
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = "sha256-WNMsPwBfd5EjeRbRtc06lCEVI2FVoLfrqL82OR0G7/c=";
  };
in
buildGraalvmNativeImage {
  pname = "bloop";
  inherit version;

  # not used, only there to satisfy buildGraalvmNativeImage's inputs
  src = "";

  buildInputs = [ deps ];

  nativeImageBuildArgs = [
    "-H:CLibraryPath=${lib.getLib graalvm11-ce}/lib"
    (lib.optionalString stdenv.isDarwin "-H:-CheckToolchain")
    "-H:Name=bloop"
    "--verbose"
  ];

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "-H:Log=registerResource:"
    "--no-fallback"
    "--no-server"
  ];

  buildPhase = ''
    runHook preBuild

    native-image bloop.bloopgun.Bloopgun -cp $CLASSPATH ''${nativeImageBuildArgs[@]}

    runHook postBuild
  '';

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook;
  propagatedBuildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 bloop $out/bin/bloop

    #Install completions
    installShellCompletion --name bloop --bash ${bloop-bash}
    installShellCompletion --name _bloop --zsh ${bloop-zsh}
    installShellCompletion --name bloop.fish --fish ${bloop-fish}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    description = "A Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way";
    maintainers = with maintainers; [ kubukoz tomahna ];
  };
}
