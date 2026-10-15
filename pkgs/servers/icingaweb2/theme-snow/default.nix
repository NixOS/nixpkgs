{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "icingaweb2-theme-snow";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N8uegR4D9OaNZhnfo75G2KQ0BvzcTuFF0VGvWtAmJ7E=";
  };

  patchPhase = ''
    # Module info contains some fancy ascii art which breaks the module list

    awk -i inplace 'BEGIN {empty=0;write=1;}{if ($0 == ""){empty++;};if(empty==2){write=0};if (write==1){print $0}}' module.info
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Snow theme for Icingaweb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-snow";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
