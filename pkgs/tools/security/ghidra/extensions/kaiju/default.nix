{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGhidraExtension,
  z3,
  gradle,
}:
let
  ghidraPlatformName =
    {
      x86_64-linux = "linux_x86_64";
      aarch64-linux = "linux_x86_64";
      x86_64-darwin = "mac_x86_64";
      aarch64-darwin = "mac_arm_64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "${stdenv.hostPlatform.system} is an unsupported platform");

  z3_lib = (
    z3.override {
      javaBindings = true;
      jdk = gradle.jdk;
    }
  );

  self = buildGhidraExtension (finalAttrs: {
    pname = "kaiju";
    version = "260608";

    src = fetchFromGitHub {
      owner = "CERTCC";
      repo = "kaiju";
      rev = finalAttrs.version;
      hash = "sha256-T8Ta8lQob7w0iPsVbZix795AjVwdo2U8yuvgCUBi5fw=";
    };

    buildInputs = [
      z3_lib
    ];

    patches = [
      ./use-gradle-dependency-cache.patch
      ./disable-groovy-worker-daemon.patch
    ];

    postPatch = ''
      if [[ -n "''${IN_GRADLE_UPDATE_DEPS-}" ]]; then
        gradlePluginRepository="https://plugins.gradle.org/m2"
        mavenRepository="https://repo.maven.apache.org/maven2"
      else
        gradlePluginRepository="file://${finalAttrs.mitmCache}/https/plugins.gradle.org/m2"
        mavenRepository="file://${finalAttrs.mitmCache}/https/repo.maven.apache.org/maven2"
      fi

      substituteInPlace settings.gradle \
        --replace-fail '@gradle-plugin-repository@' "$gradlePluginRepository" \
        --replace-fail '@maven-repository@' "$mavenRepository"

      substituteInPlace build.gradle buildSrc/build.gradle \
        --replace-fail '@maven-repository@' "$mavenRepository"
    '';

    # used to copy java bindings from nixpkgs z3 package instead of having kaiju's build.gradle build gradle from source
    # https://github.com/CERTCC/kaiju/blob/c9dbb55484b3d2a6abd9dfca2197cd00fb7ee3c1/build.gradle#L189
    preBuild = ''
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        kaijuJavacModuleArgs="--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED"
        kaijuJavacModuleArgs+=" --add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED"
        kaijuJavacModuleArgs+=" --add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED"
        kaijuJavacModuleArgs+=" --add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED"
        kaijuJavacModuleArgs+=" --add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"
        kaijuJavacModuleArgs+=" --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED"

        substituteInPlace gradle.properties \
          --replace-fail 'org.gradle.jvmargs=' "org.gradle.jvmargs=$kaijuJavacModuleArgs "
        export GRADLE_OPTS="$kaijuJavacModuleArgs ''${GRADLE_OPTS:-}"
      ''}

      mkdir -p build/cmake/z3/java-bindings
      ln -s ${lib.getOutput "java" z3_lib}/share/java/com.microsoft.z3.jar build/cmake/z3/java-bindings
      mkdir -p os/${ghidraPlatformName}
      cp ${lib.getOutput "java" z3_lib}/lib/* os/${ghidraPlatformName}
    '';

    gradleFlags = [ "-PKAIJU_SKIP_Z3_BUILD=true" ];

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta = {
      description = "Java implementation of some features of the CERT Pharos Binary Analysis Framework for Ghidra";
      homepage = "https://github.com/CERTCC/kaiju";
      downloadPage = "https://github.com/CERTCC/kaiju/releases/tag/${finalAttrs.version}";
      license = lib.licenses.bsd3;
      maintainers = [ lib.maintainers.ivyfanchiang ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        binaryBytecode # mitm cache
      ];
    };
  });
in
self
