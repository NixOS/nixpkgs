{ lib, fetchFromGitHub, poetry2nix, gettext, isocodes, xorg }:

(poetry2nix.mkPoetryApplication {

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    rev = "weblate-4.14";
    sha256 = "sha256-PsFYL/yKu90QQ0/XdbVFHY1uTU/6H+YfitqFb6Ic4E8=";
  };

  pyproject = ./pyproject.toml;
  poetrylock = ./poetry.lock;

  patches = [
    # The default timeout for the celery check is much too short upstream, so
    # we increase it. Otherwise the integration test fails. I guess this is due
    # to the fact that we test the setup very early into the initialization of
    # the server, so the load might be higher compared to production setups?
    ./longer-celery-wait-time.patch
  ];

  overrides = poetry2nix.overrides.withDefaults (
    self: super: {
      aeidon = super.aeidon.overridePythonAttrs (old: {
        src = fetchFromGitHub {
          owner = "otsaloma";
          repo = "gaupol";
          rev = "1.11";
          sha256 = "sha256-iF2ScQFYxYM2o18Cfy6U6JAZxIiZSsGrWEb4yjyECwc=";
        };
        nativeBuildInputs = [ gettext ];
        buildInputs = [ isocodes ];
        installPhase = ''
          ${self.python.interpreter} setup.py --without-gaupol install --prefix=$out
        '';
      });
      click-didyoumean = super.click-didyoumean.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.poetry ];
      });
      pyparsing = super.pyparsing.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.flit-core ];
      });
      pillow = super.pillow.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ xorg.libxcb ];
      });
      ua-parser = super.ua-parser.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pyyaml ];
        postPatch = ''
          substituteInPlace setup.py \
            --replace "pyyaml ~= 5.4.0" "pyyaml~=6.0"
        '';
      });
      jarowinkler = super.jarowinkler.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.scikit-build ];
      });
      rapidfuzz = super.rapidfuzz.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.scikit-build ];
      });
      jsonschema = super.jsonschema.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.hatch-fancy-pypi-readme ];
      });
    }
  );

  meta = with lib; {
    description = "Web based translation tool with tight version control integration";
    homepage = https://weblate.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erictapen ];
  };

}).dependencyEnv

