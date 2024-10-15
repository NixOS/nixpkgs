{ lib
, fetchPypi
, fetchpatch
, callPackage
, runCommand
, python3
, encryptionSupport ? true
, sqliteSupport ? true
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
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
    version = "0.5.0";
    disabled = python.pythonOlder "3.10";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-PkeZ7C4Srs2I10g7X1XD/HclumUwWTYj2F3J2CxN4Hs=";
    };

    patches = [
      # add entry point - https://github.com/maubot/maubot/pull/146
      (fetchpatch {
        url = "https://github.com/maubot/maubot/commit/ef6e23eccb530187dd3447b6aac2047d4a32fb83.patch";
        hash = "sha256-d5fu47F93aXZmk6MiSsxTE8pHjMKNL0FUdU+ynUqY2o=";
      })
    ];

    propagatedBuildInputs = with python.pkgs; [
      # requirements.txt
      (mautrix.override { withOlm = encryptionSupport; })
      aiohttp
      yarl
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
      setuptools
    ]
    # optional-requirements.txt
    ++ lib.optionals encryptionSupport [
      python-olm
      pycryptodome
      unpaddedbase64
    ]
    ++ lib.optionals sqliteSupport [
      sqlalchemy
    ];

    # used for plugin tests
    propagatedNativeBuildInputs = with python.pkgs; [
      pytest
      pytest-asyncio
    ];

    postInstall = ''
      rm $out/example-config.yaml
    '';

    # Setuptools is trying to do python -m maubot test
    dontUseSetuptoolsCheck = true;

    pythonImportsCheck = [
      "maubot"
    ];

    passthru = let
      wrapper = callPackage ./wrapper.nix {
        unwrapped = maubot;
        python3 = python;
      };
    in
    {
      tests = {
        simple = runCommand "${pname}-tests" { } ''
          ${maubot}/bin/mbc --help > $out
        '';
      };

      inherit python;

      plugins = callPackage ./plugins {
        maubot = maubot;
        python3 = python;
      };

      withPythonPackages = pythonPackages: wrapper { inherit pythonPackages; };

      # This adds the plugins to lib/maubot-plugins
      withPlugins = plugins: wrapper { inherit plugins; };

      # This changes example-config.yaml in module directory
      withBaseConfig = baseConfig: wrapper { inherit baseConfig; };
    };

    meta = with lib; {
      description = "Plugin-based Matrix bot system written in Python";
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
