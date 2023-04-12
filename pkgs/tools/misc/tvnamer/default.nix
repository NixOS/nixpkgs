{ lib
, python3
}:

let
  python' = python3.override {
    packageOverrides = final: prev: rec {
      # tvdb_api v3.1.0 has a hard requirement on requests-cache < 0.6
      requests-cache = prev.requests-cache.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.2";
        src = final.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-gTAjJpaGBF+OAeIonMHn6a5asi3dHihJqQk6s6tycOs=";
        };

        nativeBuildInputs = with final; [
          setuptools
        ];

        # too many changes have been made to requests-cache based on version 0.6 so
        # simply disable tests
        doCheck = false;
      });
    };
  };

  pypkgs = python'.pkgs;

in
pypkgs.buildPythonApplication rec {
  pname = "tvnamer";
  version = "3.0.4";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "dc2ea8188df6ac56439343630466b874c57756dd0b2538dd8e7905048f425f04";
  };

  propagatedBuildInputs = with pypkgs; [ tvdb_api ];

  # no tests from pypi
  doCheck = false;

  meta = with lib; {
    description = "Automatic TV episode file renamer, uses data from thetvdb.com via tvdb_api.";
    homepage = "https://github.com/dbr/tvnamer";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
