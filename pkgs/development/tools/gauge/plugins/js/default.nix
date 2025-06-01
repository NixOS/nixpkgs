{
  lib,
  nodejs,
  buildNpmPackage,
  fetchFromGitHub,
  unzip,
  gauge-unwrapped,
}:
buildNpmPackage rec {
  pname = "gauge-plugin-js";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge-js";
    rev = "v${version}";
    hash = "sha256-eFXWed/2NQphSPuGIdnpq77ZiYPEGx5bS7g5LAZhkME=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-LUwnue1kFxtifRrV8U+IQ74A2/ari75MVyZT0xLaez4=";
  npmBuildScript = "package";

  buildInputs = [ nodejs ];
  nativeBuildInputs = [ unzip ];

  postPatch = ''
    patchShebangs index.js
  '';

  installPhase = ''
    mkdir -p $out/share/gauge-plugins/js/${version}
    unzip deploy/gauge-js-${version}.zip -d $out/share/gauge-plugins/js/${version}
  '';

  meta = {
    description = "Gauge plugin that lets you write tests in JavaScript";
    homepage = "https://github.com/getgauge/gauge-js/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    inherit (gauge-unwrapped.meta) platforms;
  };
}
