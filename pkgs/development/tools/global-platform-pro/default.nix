{ stdenv, fetchFromGitHub, jdk, maven, writeText, makeWrapper, jre_headless, pcsclite }:

# TODO: This is quite a bit of duplicated logic with gephi. Factor it out?
stdenv.mkDerivation rec {
  pname = "global-platform-pro";
  version = "0.3.10-rc11"; # Waiting for release https://github.com/martinpaljak/GlobalPlatformPro/issues/128
  describeVersion = "v0.3.10-rc11-0-g8923747"; # git describe --tags --always --long --dirty
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "martinpaljak";
    repo = "GlobalPlatformPro";
    rev = "v${version}";
    sha256 = "0rk81x2y7vx1caxm6wa59fjrfxmjn7s8yxaxm764p8m2qxk3m4y2";
  };

  # This patch hardcodes the return of a git command the build system tries to
  # run. As `fetchFromGitHub` doesn't fetch a full-fledged git repository,
  # this command can only fail at build-time. As a consequence, we include the
  # `describeVersion` variable defined above here.
  #
  # See upstream issue https://github.com/martinpaljak/GlobalPlatformPro/issues/129
  patches = [ (writeText "${name}-version.patch" ''
    diff --git a/pom.xml b/pom.xml
    index 1e5a82d..1aa01fe 100644
    --- a/pom.xml
    +++ b/pom.xml
    @@ -121,14 +121,10 @@
                         </execution>
                     </executions>
                     <configuration>
    -                    <executable>git</executable>
    +                    <executable>echo</executable>
                         <outputFile>target/generated-resources/pro/javacard/gp/pro_version.txt</outputFile>
                         <arguments>
    -                        <argument>describe</argument>
    -                        <argument>--tags</argument>
    -                        <argument>--always</argument>
    -                        <argument>--long</argument>
    -                        <argument>--dirty</argument>
    +                        <argument>${describeVersion}</argument>
                         </arguments>
                     </configuration>
                 </plugin>
  '') ];

  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src patches;
    nativeBuildInputs = [ jdk maven ];
    installPhase = ''
      # Download the dependencies
      while ! mvn package "-Dmaven.repo.local=$out/.m2" -Dmaven.wagon.rto=5000; do
        echo "timeout, restart maven to continue downloading"
      done

      # And keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files
      # with lastModified timestamps inside
      find "$out/.m2" -type f \
        -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' \
        -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "15bbi7z9v601all9vr2azh8nk8rpz2vd91yvvw8id6birnbhn3if";
  };

  nativeBuildInputs = [ jdk maven makeWrapper ];

  buildPhase = ''
    cp -dpR "${deps}/.m2" ./
    chmod -R +w .m2
    mvn package --offline -Dmaven.repo.local="$(pwd)/.m2"
  '';

  installPhase = ''
    mkdir -p "$out/lib/java" "$out/share/java"
    cp -R target/apidocs "$out/doc"
    cp target/gp.jar "$out/share/java"
    makeWrapper "${jre_headless}/bin/java" "$out/bin/gp" \
      --add-flags "-jar '$out/share/java/gp.jar'" \
      --prefix LD_LIBRARY_PATH : "${pcsclite.out}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Command-line utility for managing applets and keys on Java Cards";
    longDescription = ''
      This command-line utility can be used to manage applets and keys
      on Java Cards. It is made available as the `gp` executable.

      The executable requires the PC/SC daemon running for correct execution.
      If you run NixOS, it can be enabled with `services.pcscd.enable = true;`.
    '';
    homepage = https://github.com/martinpaljak/GlobalPlatformPro;
    license = with licenses; [ lgpl3 ];
    platforms = platforms.all;
  };
}
