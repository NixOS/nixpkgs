{ lib
, fetchPypi
, fetchpatch
, runCommand
, python3
, encryptionSupport ? true
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      # aiosqlite>=0.16,<0.19
      aiosqlite = prev.aiosqlite.overridePythonAttrs (old: rec {
        version = "0.18.0";
        src = old.src.override {
          rev = "refs/tags/v${version}";
          hash = "sha256-yPGSKqjOz1EY5/V0oKz2EiZ90q2O4TINoXdxHuB7Gqk=";
        };
      });
      # mautrix>=0.19.8,<0.20
      mautrix = prev.mautrix.overridePythonAttrs (old: rec {
        version = "0.19.16";
        disabled = final.pythonOlder "3.8";
        checkInputs = old.checkInputs ++ [ final.sqlalchemy ];
        SQLALCHEMY_SILENCE_UBER_WARNING = true;
        src = old.src.override {
          rev = "refs/tags/v${version}";
          hash = "sha256-aZlc4+J5Q+N9qEzGUMhsYguPdUy+E5I06wrjVyqvVDk=";
        };
      });
      # mautrix has a runtime error with new ruamel-yaml since 0.17.22 changed the interface
      ruamel-yaml = prev.ruamel-yaml.overridePythonAttrs (prev: rec {
        version = "0.17.21";
        src = prev.src.override {
          version = version;
          hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
        };
      });
      # SQLAlchemy>=1,<1.4
      # SQLAlchemy 2.0's derivation is very different, so don't override, just write it from scratch
      # (see https://github.com/NixOS/nixpkgs/blob/65dbed73949e4c0207e75dcc7271b29f9e457670/pkgs/development/python-modules/sqlalchemy/default.nix)
      sqlalchemy = final.buildPythonPackage rec {
        pname = "SQLAlchemy";
        version = "1.3.24";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };

        postInstall = ''
          sed -e 's:--max-worker-restart=5::g' -i setup.cfg
        '';

        # tests are pretty annoying to set up for this version, and these dependency overrides are already long enough
        doCheck = false;
      };
    };
  };

  maubot = python.pkgs.buildPythonPackage rec {
    pname = "maubot";
    version = "0.4.1";
    disabled = python.pythonOlder "3.8";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Ro2PPgF8818F8JewPZ3AlbfWFNNHKTZkQq+1zpm3kk4=";
    };

    patches = [
      # add entry point - https://github.com/maubot/maubot/pull/146
      (fetchpatch {
        url = "https://github.com/maubot/maubot/commit/283f0a3ed5dfae13062b6f0fd153fbdc477f4381.patch";
        sha256 = "0yn5357z346qzy5v5g124mgiah1xsi9yyfq42zg028c8paiw8s8x";
      })
      # allow running "mbc build" in a nix derivation
      ./allow-building-plugins-from-nix-store.patch
    ];

    propagatedBuildInputs = with python.pkgs; [
      # requirements.txt
      mautrix
      aiohttp
      yarl
      sqlalchemy
      asyncpg
      aiosqlite
      commonmark
      ruamel-yaml
      attrs
      bcrypt
      packaging
      click
      colorama
      questionary
      jinja2
    ]
    # optional-requirements.txt
    ++ lib.optionals encryptionSupport [
      python-olm
      pycryptodome
      unpaddedbase64
    ];

    postInstall = ''
      rm $out/example-config.yaml
    '';

    passthru.tests = {
      simple = runCommand "${pname}-tests" { } ''
        ${maubot}/bin/mbc --help > $out
      '';
    };

    # Setuptools is trying to do python -m maubot test
    dontUseSetuptoolsCheck = true;

    pythonImportsCheck = [
      "maubot"
    ];

    meta = with lib; {
      description = "A plugin-based Matrix bot system written in Python";
      homepage = "https://maubot.xyz/";
      changelog = "https://github.com/maubot/maubot/blob/v${version}/CHANGELOG.md";
      license = licenses.agpl3Plus;
      # Presumably, people running "nix run nixpkgs#maubot" will want to run the tool
      # for interacting with Maubot rather than Maubot itself, which should be used as
      # a NixOS module.
      mainProgram = "mbc";
      maintainers = with maintainers; [ chayleaf ];
    };
  };

in
maubot
