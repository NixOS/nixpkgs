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
          ${gradleWithToolchains}/bin/gradle build
        '';
      };
    }
  else { }
)
