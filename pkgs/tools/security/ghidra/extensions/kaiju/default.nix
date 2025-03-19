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

  self = buildGhidraExtension rec {
    pname = "kaiju";
    version = "250220";

    src = fetchFromGitHub {
      owner = "CERTCC";
      repo = "kaiju";
      rev = version;
      hash = "sha256-o9VAmZl0dJfap5WccDXUWS4PSKvb/DYmeZotKZ1v/ps=";
    };

    buildInputs = [
      z3_lib
    ];

    # used to copy java bindings from nixpkgs z3 package instead of having kaiju's build.gradle build gradle from source
    # https://github.com/CERTCC/kaiju/blob/c9dbb55484b3d2a6abd9dfca2197cd00fb7ee3c1/build.gradle#L189
    preBuild = ''
      mkdir -p build/cmake/z3/java-bindings
      ln -s ${lib.getOutput "lib" z3_lib}/lib/com.microsoft.z3.jar build/cmake/z3/java-bindings
      mkdir -p os/${ghidraPlatformName}
      cp ${lib.getOutput "lib" z3_lib}/lib/* os/${ghidraPlatformName}
    '';

    gradleFlags = [ "-PKAIJU_SKIP_Z3_BUILD=true" ];

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta = {
      description = "A Java implementation of some features of the CERT Pharos Binary Analysis Framework for Ghidra";
      homepage = "https://github.com/CERTCC/kaiju";
      downloadPage = "https://github.com/CERTCC/kaiju/releases/tag/${version}";
      license = lib.licenses.bsd3;
      maintainers = [ lib.maintainers.ivyfanchiang ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  };
in
self
