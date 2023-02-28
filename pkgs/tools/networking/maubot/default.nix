{ lib
, fetchpatch
, python3
, runCommand
, encryptionSupport ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      aiosqlite = super.aiosqlite.overrideAttrs (old: rec {
        version = "0.18.0";
        src = old.src.override {
          rev = "refs/tags/v${version}";
          hash = "sha256-yPGSKqjOz1EY5/V0oKz2EiZ90q2O4TINoXdxHuB7Gqk=";
        };
      });
      sqlalchemy = super.buildPythonPackage rec {
        pname = "SQLAlchemy";
        version = "1.3.24";

        src = super.fetchPypi {
          inherit pname version;
          sha256 = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };

        postInstall = ''
          sed -e 's:--max-worker-restart=5::g' -i setup.cfg
        '';

        doCheck = false;
      };
    };
  };

  self = with python.pkgs; buildPythonPackage rec {
    pname = "maubot";
    version = "0.4.1";
    disabled = pythonOlder "3.8";

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
      ./allow-building-plugins-from-nix-store.patch
    ];

    propagatedBuildInputs = [
      # requirements.txt
      mautrix
      aiohttp
      yarl
      sqlalchemy
      asyncpg
      aiosqlite
      CommonMark
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
        ${self}/bin/mbc --help > $out
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
      maintainers = with maintainers; [ chayleaf ];
    };
  };

in
self
