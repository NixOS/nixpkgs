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
    sha256 = "1c974v85mbsis52y2knwzh33996q8sza7pqrcs6ydx033s0rxjrp";
  };

  patchPhase = ''
    # Module info contains some fancy ascii art which breaks the module list

    awk -i inplace 'BEGIN {empty=0;write=1;}{if ($0 == ""){empty++;};if(empty==2){write=0};if (write==1){print $0}}' module.info
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = with lib; {
    description = "Snow theme for Icingaweb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-snow";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
