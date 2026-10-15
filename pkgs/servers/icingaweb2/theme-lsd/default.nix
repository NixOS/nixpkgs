{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "icingaweb2-theme-lsd";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XHyciPvFz4/Oeboy1cJzZw3VEYesYHfL9suSrDQCXpw=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Psychedelic theme for IcingaWeb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-lsd";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
