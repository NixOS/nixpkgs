{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "semver-tool";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "fsaintjacques";
    repo = pname;
    rev = version;
    sha256 = "sha256-LqZTHFiis4BYL1bnJoeuW56wf8+o38Ygs++CV9CKNhM=";
  };

  dontBuild = true; # otherwise we try to 'make' which fails.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install src/semver $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/fsaintjacques/semver-tool";
    description = "semver bash implementation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.qyliss ];
    mainProgram = "semver";
  };
}
