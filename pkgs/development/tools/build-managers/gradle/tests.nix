{ runCommand, testers, jdk11, jdk17, stdenv }:
{ gradle, gradleWithToolchains ? null }:

{
  version = testers.testVersion {
    package = gradle;
  };
} // (
  if gradleWithToolchains != null then
    let
      src = ./tests/toolchain;
    in
    {
      checkToolchain = stdenv.mkDerivation {
        nativeBuildInputs = [ gradleWithToolchains ];
        name = "gradle-toolchain";
        src = ./tests/toolchain;
        installPhase = ''
          mkdir $out
          cp -r * $out
          cd $out
          set -o pipefail
          ${gradleWithToolchains}/bin/gradle :proj1:run :proj2:run | tee output.log
          if [ $? != 0 ]; then
            echo "Non-zero output from Gradle"
            exit $?
          fi;

          echo "Correctly detected JDKs (should have 11 and 17):"
          grep "JDK version: 11" output.log && grep "JDK version: 17" output.log
        '';
      };
    }
  else { }
)
