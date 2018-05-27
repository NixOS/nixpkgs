{ pkgs
, python
, overrides ? (self: super: {})
}:

with pkgs.lib;

let
  src = pkgs.fetchFromGitHub {
    owner = "DataDog";
    repo = "integrations-core";
    rev = "7be76e73969a8b9c993903681b300e1dd32f4b4d";
    sha256 = "1qsqzm5iswgv9jrflh5mvbz9a7js7jf42cb28lzdzsp45iwfs2aa";
  };
  version = "git-2018-05-27";

  buildIntegration = { pname, ... }@args: python.pkgs.buildPythonPackage (args // {
    inherit src version;
    name = "datadog-integration-${pname}-${version}";

    postPatch = ''
      # jailbreak install_requires
      sed -i 's/==.*//' requirements.in
      cp requirements.in requirements.txt
    '';
    sourceRoot = "source/${args.sourceRoot or pname}";
    doCheck = false;
  });

  packages = (self: {
    python = python.withPackages (ps: with self; [ disk network postgres nginx mongo ]);

    datadog_checks_base = buildIntegration {
      pname = "checks-base";
      sourceRoot = "datadog_checks_base";
      propagatedBuildInputs = with self; with python.pkgs; [ requests protobuf prometheus_client uuid simplejson uptime ];
    };

    disk = buildIntegration {
      pname = "disk";
      propagatedBuildInputs = with self; with python.pkgs; [ datadog_checks_base psutil ];
    };

    network = buildIntegration {
      pname = "network";
      propagatedBuildInputs = with self; with python.pkgs; [ datadog_checks_base psutil ];
    };

    postgres = buildIntegration {
      pname = "postgres";
      propagatedBuildInputs = with self; with python.pkgs; [ datadog_checks_base pg8000 psycopg2 ];
    };

    nginx = buildIntegration {
      pname = "nginx";
      propagatedBuildInputs = with self; with python.pkgs; [ datadog_checks_base ];
    };

    mongo = buildIntegration {
      pname = "mongo";
      propagatedBuildInputs = with self; with python.pkgs; [ datadog_checks_base pymongo ];
    };

  });

in fix' (extends overrides packages)
