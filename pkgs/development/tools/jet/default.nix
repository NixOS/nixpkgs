{ stdenv, lib, graalvm11-ce, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jet";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-RCEIIZfPmOLW3akjEgaEas4xOtYxL6lQsxDv2szB8K4";
  };

  reflectionJson = fetchurl {
    url = "https://raw.githubusercontent.com/borkdude/${pname}/v${version}/reflection.json";
    sha256 = "sha256-mOUiKEM5tYhtpBpm7KtslyPYFsJ+Wr+4ul6Zi4aS09Q=";
  };

  dontUnpack = true;

  buildInputs = [ graalvm11-ce ];

  buildPhase = ''
    runHook preBuild

    # https://github.com/borkdude/jet/blob/v0.1.0/script/compile#L16-L29
    args=("-jar" "$src"
          "-H:CLibraryPath=${graalvm11-ce.lib}/lib"
          # Required to build jet on darwin. Do not remove.
          "${lib.optionalString stdenv.isDarwin "-H:-CheckToolchain"}"
          "-H:Name=jet"
          "-H:+ReportExceptionStackTraces"
          "-J-Dclojure.spec.skip-macros=true"
          "-J-Dclojure.compiler.direct-linking=true"
          "-H:IncludeResources=JET_VERSION"
          "-H:ReflectionConfigurationFiles=${reflectionJson}"
          "--initialize-at-build-time"
          "-H:Log=registerResource:"
          "--verbose"
          "--no-fallback"
          "--no-server"
          "-J-Xmx3g")

     native-image ''${args[@]}

     runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp jet $out/bin/jet
  '';

  meta = with lib; {
    description = "CLI to transform between JSON, EDN and Transit, powered with a minimal query language";
    homepage = "https://github.com/borkdude/jet";
    license = licenses.epl10;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ ericdallo ];
  };
}
