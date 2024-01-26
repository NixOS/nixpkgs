{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_18
, nix-update-script
, fetchpatch
}:
buildNpmPackage rec {
  pname = "db-rest";
  version = "6.0.3";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "derhuerst";
    repo = pname;
    rev = version;
    hash = "sha256-kHT8/8ivqcP6YRBvkZ4jpJ/xBMM1PddLgV1Z/MFmSTM=";
  };

  patches = [
    # add files and bin property to package.json
    # keep until https://github.com/derhuerst/db-rest/pull/37 is merged and released
    (fetchpatch {
      url = "https://github.com/derhuerst/db-rest/commit/7d2c8bebdd5e8152b181748e3c36683ecf9e71c9.patch";
      hash = "sha256-KyNcvSJLQrX8BO/4814wefeeC+s0pvM2ng44q6diU24=";
    })
  ];

  npmDepsHash = "sha256-d/Qs194TU4ooy6GsBsZhrf5H1iPCUnlieBgtuqfAtkQ=";

  preConfigure = ''
    patchShebangs ./build/index.js
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A clean REST API wrapping around the Deutsche Bahn API";
    homepage = "https://v6.db.transport.rest/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "db-rest";
  };
}
