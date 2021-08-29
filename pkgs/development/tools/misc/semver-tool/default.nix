{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "semver-tool";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "fsaintjacques";
    repo = pname;
    rev = version;
    sha256 = "sha256-coy/g4nEvSN+0/aqK2r3EEIaoUcnsZhzX66H1qsK9ac=";
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
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.qyliss ];
  };
}
