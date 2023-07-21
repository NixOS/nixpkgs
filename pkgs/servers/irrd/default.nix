{ poetry2nix, pkgs, lib }:

let
  pythonPackages = (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (import ./poetry-git-overlay.nix { inherit pkgs; })
      (self: super: {

        irrd = super.irrd.overridePythonAttrs (old: {
          prePatch = ''
            sed -i '/wheel/d' setup.py
          '';

          meta = old.meta // {
            description = "Internet Routing Registry daemon version 4 is an IRR database server, processing IRR objects in the RPSL format.";
            license = lib.licenses.mit;
            homepage = "https://github.com/irrdnet/irrd";
            maintainers = [ lib.maintainers.n0emis ];
          };
        });

        coredis = super.coredis.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [
            super.setuptools
          ];
        });

        ariadne = super.ariadne.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [
            super.setuptools
          ];
        });

        hiredis = super.hiredis.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "CVE-2021-32765"
            ];
          };
        });

        pydantic = super.pydantic.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "CVE-2020-10735"
            ];
          };
        });

        redis = super.redis.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "CVE-2023-28858"
              "CVE-2023-28859"
            ];
          };
        });

        requests = super.requests.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "CVE-2023-32681"
            ];
          };
        });

        sqlalchemy = super.sqlalchemy.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "PVE-2022-51668"
            ];
          };
        });

        starlette = super.starlette.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "CVE-2023-29159"
              "CVE-2023-30798"
            ];
          };
        });

        ujson = super.ujson.overridePythonAttrs (old: {
          meta = old.meta // {
            knownVulnerabilities = [
              "CVE-2021-45958"
              "CVE-2022-31116"
              "CVE-2022-31117"
            ];
          };
        });

      })
    ];
  }).python.pkgs;
in pythonPackages.irrd

