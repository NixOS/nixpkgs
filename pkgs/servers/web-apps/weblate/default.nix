{ lib, fetchFromGitHub, poetry2nix, gettext, isocodes, xorg }:

(poetry2nix.mkPoetryApplication {
  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    rev = "weblate-4.12";
    sha256 = "sha256-8SVwbwxXZX7HCers7kgjXplPirNHeC4Zkhm6IDYA2sA=";
  };
  pyproject = ./pyproject.toml;
  poetrylock = ./poetry.lock;
  # The default timeout for the celery check is much too short upstream, so
  # we increase it. I guess this is due to the fact that we test the setup
  # very early into the initialization of the server, so the load might be
  # higher compared to production setups?
  patches = [ ./longer-celery-wait-time.patch ];
  meta = with lib; {
    description = "Web based translation tool with tight version control integration";
    homepage = https://weblate.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erictapen ];
  };
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

    }
  );
}).dependencyEnv

