<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, jdk8, maven, makeWrapper, jre8_headless, pcsclite, proot, zlib }:

let
  mavenJdk8 = maven.override {
    jdk = jdk8;
  };

  defineMvnWrapper = ''
    mvn()
    {
        # One of the deps that are downloaded and run needs zlib.
        export LD_LIBRARY_PATH="${lib.makeLibraryPath [zlib]}"
        # Give access to ELF interpreter under FHS path, to be able to run
        # prebuilt binaries.
        "${lib.getExe proot}" -b "${stdenv.cc.libc}/lib:/lib64" mvn "$@"
    }
  '';
in
mavenJdk8.buildMavenPackage rec {
  pname = "global-platform-pro";
  version = "20.01.23";
  GPPRO_VERSION = "v20.01.23-0-g5ad373b"; # git describe --tags --always --long --dirty
=======
{ lib, stdenv, fetchFromGitHub, jdk8, maven, makeWrapper, jre8_headless, pcsclite }:

let jdk = jdk8; jre_headless = jre8_headless; in
# TODO: This is quite a bit of duplicated logic with gephi. Factor it out?
stdenv.mkDerivation rec {
  pname = "global-platform-pro";
  version = "18.09.14";
  GPPRO_VERSION = "18.09.14-0-gb439b52"; # git describe --tags --always --long --dirty
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "martinpaljak";
    repo = "GlobalPlatformPro";
<<<<<<< HEAD
    rev = "v${version}";
    sha256 = "sha256-z38I61JR4oiAkImkbwcvXoK5QsdoR986dDrOzhHsCeY=";
  };

  mvnHash = "sha256-+297ttqBT4Q4NyNIvTYTtiDrB1dfmuu9iWmAxxBZiW8=";

  nativeBuildInputs = [ jdk8 makeWrapper ];

  # Fix build error due to missing .git directory:
  #  Failed to execute goal pl.project13.maven:git-commit-id-plugin:4.0.0:revision (retrieve-git-info) on project gppro: .git directory is not found! Please specify a valid [dotGitDirectory] in your pom.xml -> [Help 1]
  mvnParameters = "-Dmaven.gitcommitid.skip=true";

  mvnFetchExtraArgs = {
    preConfigure = defineMvnWrapper;
  };

  preConfigure = defineMvnWrapper;

  installPhase = ''
    mkdir -p "$out/lib/java" "$out/share/java"
    cp tool/target/gp.jar "$out/share/java"
    makeWrapper "${jre8_headless}/bin/java" "$out/bin/gp" \
=======
    rev = version;
    sha256 = "1vws6cbgm3mrwc2xz9j1y262vw21x3hjc9m7rqc4hn3m7gjpwsvg";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-${version}-deps";
    inherit src;
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
    outputHash = "1qwgvz6l5wia8q5824c9f3iwyapfskljhqf1z09fw6jjj1jy3b15";
  };

  nativeBuildInputs = [ jdk maven makeWrapper ];

  buildPhase = ''
    cp -dpR "${deps}/.m2" ./
    chmod -R +w .m2
    mvn package --offline -Dmaven.repo.local="$(pwd)/.m2"
  '';

  installPhase = ''
    mkdir -p "$out/lib/java" "$out/share/java"
    cp target/gp.jar "$out/share/java"
    makeWrapper "${jre_headless}/bin/java" "$out/bin/gp" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --add-flags "-jar '$out/share/java/gp.jar'" \
      --prefix LD_LIBRARY_PATH : "${pcsclite.out}/lib"
  '';

  meta = with lib; {
    description = "Command-line utility for managing applets and keys on Java Cards";
    longDescription = ''
      This command-line utility can be used to manage applets and keys
      on Java Cards. It is made available as the `gp` executable.

      The executable requires the PC/SC daemon running for correct execution.
      If you run NixOS, it can be enabled with `services.pcscd.enable = true;`.
    '';
    homepage = "https://github.com/martinpaljak/GlobalPlatformPro";
    sourceProvenance = with sourceTypes; [
      fromSource
<<<<<<< HEAD
      binaryBytecode # deps
=======
      binaryBytecode  # deps
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "gp";
<<<<<<< HEAD
=======
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
