{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "semver-tool";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "fsaintjacques";
    repo = pname;
    rev = version;
    sha256 = "0lpwsa86qb5w6vbnsn892nb3qpxxx9ifxch8pw3ahzx2dqhdgnrr";
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
