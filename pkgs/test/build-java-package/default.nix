{
  lib,
  buildJavaPackage,
  runCommand,
  writeTextDir,
}:

let
  # Basic standalone Java lib
  basicSrc = writeTextDir "src/main/java/org/nixos/test/Greeter.java" ''
    package org.nixos.test;

    public class Greeter {
      public static String greet(String name) {
        return "Hello, " + name + "!";
      }
    }
  '';

  basic = buildJavaPackage (finalAttrs: {
    pname = "test-greeter";
    version = "1.0.0";
    src = basicSrc;

    meta = {
      description = "Basic Java test package";
      license = lib.licenses.mit;
    };
  });

  # Package with a dependency on another buildJavaPackage
  dependentSrc = writeTextDir "src/main/java/org/nixos/test/App.java" ''
    package org.nixos.test;

    public class App {
      public static void main(String[] args) {
        System.out.println(Greeter.greet("Nixpkgs"));
      }
    }
  '';

  dependent = buildJavaPackage (finalAttrs: {
    pname = "test-app";
    version = "2.0.0";
    src = dependentSrc;
    classpath = [ basic ];

    meta = {
      description = "Dependent Java test package";
      license = lib.licenses.mit;
    };
  });

  # Package with custom compiler flags and javaRelease = null
  customFlagsSrc = writeTextDir "src/main/java/org/nixos/test/Custom.java" ''
    package org.nixos.test;

    public class Custom {
      public static int getValue() {
        return 42;
      }
    }
  '';

  customFlags = buildJavaPackage (finalAttrs: {
    pname = "test-custom-flags";
    version = "1.0.0";
    src = customFlagsSrc;
    javaRelease = null;
    javacFlags = [
      "-source=8"
      "-target=8"
    ];

    meta = {
      description = "Custom javac flags test package";
      license = lib.licenses.mit;
    };
  });

  # Package with bundled resources
  resourcesSrc = runCommand "test-resources-src" { } ''
    mkdir -p $out/src/main/java/org/nixos/test
    cat <<'EOF' > $out/src/main/java/org/nixos/test/ResourceHolder.java
    package org.nixos.test;
    public class ResourceHolder {}
    EOF

    mkdir -p $out/src/main/resources
    echo "test_key=test_value" > $out/src/main/resources/test.properties
  '';

  resources = buildJavaPackage (finalAttrs: {
    pname = "test-resources";
    version = "1.0.0";
    src = resourcesSrc;

    meta = {
      description = "Resource bundling test package";
      license = lib.licenses.mit;
    };
  });

  overridden = basic.overrideAttrs (old: {
    pname = "test-greeter-overridden";
  });

in
runCommand "build-java-package-tests"
  {
    passthru = {
      inherit
        basic
        dependent
        customFlags
        resources
        overridden
        ;
    };
  }
  ''
    set -Eeuo pipefail

    test -f "${basic}/share/java/test-greeter-1.0.0.jar"
    test -L "${basic}/share/java/test-greeter.jar"

    test -f "${dependent}/share/java/test-app-2.0.0.jar"
    test -L "${dependent}/share/java/test-app.jar"

    test -f "${customFlags}/share/java/test-custom-flags-1.0.0.jar"
    test -L "${customFlags}/share/java/test-custom-flags.jar"

    test -f "${resources}/share/java/test-resources-1.0.0.jar"
    test -L "${resources}/share/java/test-resources.jar"

    test -f "${overridden}/share/java/test-greeter-overridden-1.0.0.jar"
    test -L "${overridden}/share/java/test-greeter-overridden.jar"

    mkdir $out
    touch $out/success
  ''
