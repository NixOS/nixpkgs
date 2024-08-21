{ lib, stdenv, fetchFromGitHub, jdk8, maven, makeWrapper, jre8_headless, pcsclite, proot, zlib }:

let
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
maven.buildMavenPackage rec {
  pname = "global-platform-pro";
  version = "20.01.23";
  GPPRO_VERSION = "v20.01.23-0-g5ad373b"; # git describe --tags --always --long --dirty

  src = fetchFromGitHub {
    owner = "martinpaljak";
    repo = "GlobalPlatformPro";
    rev = "v${version}";
    sha256 = "sha256-z38I61JR4oiAkImkbwcvXoK5QsdoR986dDrOzhHsCeY=";
  };

  mvnJdk = jdk8;
  mvnHash = "sha256-es8M7gV2z1V9VpWOxanJwQyiemabiUw3n4heJB8Q75A=";

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
      --add-flags "-jar '$out/share/java/gp.jar'" \
      --prefix LD_LIBRARY_PATH : "${lib.getLib pcsclite}/lib"
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
      binaryBytecode # deps
    ];
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "gp";
  };
}
