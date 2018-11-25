{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "semver-tool-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "fsaintjacques";
    repo = "semver-tool";
    rev = version;
    sha256 = "0lpwsa86qb5w6vbnsn892nb3qpxxx9ifxch8pw3ahzx2dqhdgnrr";
  };

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    mkdir -p $out/bin
    install src/semver $out/bin
  '';

  meta = with lib; {
    homepage = https://github.com/fsaintjacques/semver-tool;
    description = "semver bash implementation";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.qyliss ];
  };
}
