{ lib
, nodejs
, buildNpmPackage
, fetchFromGitHub
, unzip
, gauge-unwrapped
}:
buildNpmPackage rec {
  pname = "gauge-plugin-js";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge-js";
    rev = "v${version}";
    hash = "sha256-qCn4EKndd0eM3X0+aLrCwvmEG5fgUfpVm76cg/n7B84=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-5XkFwCFqNMe5xc/Tx69uUV7KMtgY7Z3zE7hbtxYqRf0=";
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
