{ poetry2nix, pkgs, lib }:

let
  inherit (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (import ./poetry-git-overlay.nix { inherit pkgs; })
      (self: super: {
        more-properties = super.more-properties.overridePythonAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "madman-bob";
            repo = "python-more-properties";
            rev = old.version;
            sha256 = "sha256-dKG97rw5IG19m7u3ZDBM2yGScL5cFaKBvGZxPVJaUTE=";
          };
          postPatch = ''
            sed -i -e '/dataclasses/d' requirements.txt
            cp ./pypi_upload/setup.py setup.py
            substituteInPlace setup.py \
              --replace "parents[1]" "parents[0]"
          '';
        });
        dataclasses-serialization = super.dataclasses-serialization.overridePythonAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "madman-bob";
            repo = "python-dataclasses-serialization";
            rev = old.version;
            sha256 = "sha256-jLMR2D01KgzHHRP0zduMBJt8xgBmIquWLCjZYLo2/AA=";
          };
          postPatch = ''
            sed -i -e '/dataclasses/d' requirements.txt
            cp ./pypi_upload/setup.py setup.py
            substituteInPlace setup.py \
              --replace "parents[1]" "parents[0]"
          '';
        });
        dataclasses = null;
      })
    ];
  }) python;
  env = python.withPackages (p: [ p.dmarc-metrics-exporter ]);
in

pkgs.writeShellScriptBin "prometheus-dmarc-exporter" ''
  export PYTHONPATH="${env}/lib/${env.libPrefix}/site-packages''${PYTHONPATH:+:}''${PYTHONPATH}"
  exec ${env}/bin/python3 -m dmarc_metrics_exporter "$@"
''
