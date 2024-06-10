{ lib
, stdenv
, python3
, fetchPypi
, fetchpatch
, src
, version
}:

let
  buildAzureCliPackage = with py.pkgs; buildPythonPackage;

  overrideAzureMgmtPackage = package: version: extension: hash:
    package.overridePythonAttrs (oldAttrs: {
      inherit version;

      src = fetchPypi {
        inherit (oldAttrs) pname;
        inherit version hash extension;
      };
    });

  py = python3.override {
    packageOverrides = self: super: {
      inherit buildAzureCliPackage;

      # core and the actual application are highly coupled
      azure-cli-core = buildAzureCliPackage {
        pname = "azure-cli-core";
        inherit version src;

        sourceRoot = "${src.name}/src/azure-cli-core";

        patches = [
          # Adding the possibility to configure an immutable configuration dir via `AZURE_IMMUTABLE_DIR`.
          # This enables us to place configuration files that alter the behavior of the CLI in the Nix store.
          #
          # This is a downstream patch without an commit or PR upstream.
          # There is an issue to discuss possible solutions upstream:
          # https://github.com/Azure/azure-cli/issues/28093
          ./0001-optional-immutable-configuration-dir.patch
        ];

        propagatedBuildInputs = with self; [
          argcomplete
          azure-cli-telemetry
          azure-common
          azure-mgmt-core
          cryptography
          distro
          humanfriendly
          jmespath
          knack
          msal-extensions
          msal
          msrestazure
          packaging
          paramiko
          pkginfo
          psutil
          pyjwt
          pyopenssl
          requests
        ];

        nativeCheckInputs = with self; [ pytest ];

        doCheck = stdenv.isLinux;

        # ignore tests that does network call, or assume powershell
        checkPhase = ''
          python -c 'import azure.common; print(azure.common)'

          PYTHONPATH=$PWD:${src}/src/azure-cli-testsdk:$PYTHONPATH HOME=$TMPDIR pytest \
            azure/cli/core/tests \
            --ignore=azure/cli/core/tests/test_profile.py \
            --ignore=azure/cli/core/tests/test_generic_update.py \
            --ignore=azure/cli/core/tests/test_cloud.py \
            --ignore=azure/cli/core/tests/test_extension.py \
            -k 'not metadata_url and not test_send_raw_requests and not test_format_styled_text_legacy_powershell'
        '';

        pythonImportsCheck = [
          "azure.cli.telemetry"
          "azure.cli.core"
        ];
      };

      azure-cli-telemetry = buildAzureCliPackage {
        pname = "azure-cli-telemetry";
        version = "1.1.0";
        inherit src;

        sourceRoot = "${src.name}/src/azure-cli-telemetry";

        propagatedBuildInputs = with self; [
          applicationinsights
          portalocker
        ];

        nativeCheckInputs = with self; [ pytest ];
        # ignore flaky test
        checkPhase = ''
          cd azure
          HOME=$TMPDIR pytest -k 'not test_create_telemetry_note_file_from_scratch'
        '';
      };

      azure-keyvault-keys = overrideAzureMgmtPackage super.azure-keyvault-keys "4.9.0b3" "tar.gz" "sha256-qoseyf6WqBEG8vPc1hF17K46AWk8Ba8V9KRed4lOlGo=";
      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "1.0.0" "zip" "sha256-woeix9703hn5LAwxugKGf6xvW433G129qxkoi7RV/Fs=";
      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "17.3.0" "tar.gz" "sha256-/JSIGmrNuKlTPzcbb3stPq6heJ65VQFLJKkI1t/nWZE=";
      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip" "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";
      azure-mgmt-botservice = overrideAzureMgmtPackage super.azure-mgmt-botservice "2.0.0b3" "zip" "sha256-XZGQOeMw8usyQ1tl8j57fZ3uqLshomHY9jO/rbpQOvM=";
      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip" "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";
      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "30.6.0" "tar.gz" "sha256-TYDXI+xtTLlYNhfr7AcW59dLJzKsuu0CPtLjzHBT0A4=";
      azure-mgmt-core = overrideAzureMgmtPackage super.azure-mgmt-core "1.3.2" "zip" "sha256-B/Sv6COlXXBLBI1h7f3BMYwFHtWfJEAyEmNQvpXp1QE=";
      azure-mgmt-datalake-store = overrideAzureMgmtPackage super.azure-mgmt-datalake-store "0.5.0" "zip" "sha256-k3bTVJVmHRn4rMVgT2ewvFlJOxg1u8SA+aGVL5ABekw=";
      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip" "sha256-WVScTEBo8mRmsQl7V0qOUJn7LNbIvgoAOVsG07KeJ40=";
      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "8.0.0" "zip" "sha256-QHwtrLM1E/++nKS+Wt216dS64Mt++mE8P31THve/jeg=";
      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "10.2.0b2" "zip" "sha256-QcHY1wCwQyVOEdUi06/wEa4dqJH5Ccd33gJ1Sju0qZA=";
      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "10.1.0" "zip" "sha256-MZqhSBkwypvEefhoEWEPsBUFidWYD7qAX6edcBDDSSA=";
      azure-mgmt-extendedlocation = overrideAzureMgmtPackage super.azure-mgmt-extendedlocation "1.0.0b2" "zip" "sha256-mjfH35T81JQ97jVgElWmZ8P5MwXVxZQv/QJKNLS3T8A=";
      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "10.0.0b1" "zip" "sha256-1CiZuTXYhIb74eGQZUJHHzovYNnnVd3Ydu1UCy2Bu00=";
      azure-mgmt-kusto = (overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "sha256-nri3eB/UQQ7p4gfNDDmDuvnlhBS1tKGISdCYVuNrrN4=").overridePythonAttrs (attrs: {
        propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ self.msrest self.msrestazure ];
      });
      azure-mgmt-maps = overrideAzureMgmtPackage super.azure-mgmt-maps "2.0.0" "zip" "sha256-OE4X92potwCk+YhHiUXDqXIXEcBAByWv38tjz4ToXw4=";
      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "9.0.0" "zip" "sha256-TI7l8sSQ2QUgPqiE3Cu/F67Wna+KHbQS3fuIjOb95ZM=";
      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "5.0.0" "zip" "sha256-eL9KJowxTF7hZJQQQCNJZ7l+rKPFM8wP5vEigt3ZFGE=";
      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "10.1.0" "zip" "sha256-eJiWTOCk2C79Jotku9bKlu3vU6H8004hWrX+h76MjQM=";
      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b4" "zip" "sha256-aB16xyrhNYHJeitvdCeV+kik21B2LC+5/OSDQIGwTpI=";
      azure-mgmt-privatedns = overrideAzureMgmtPackage super.azure-mgmt-privatedns "1.0.0" "zip" "sha256-tg8W5D97KRWCxfV7rhsIMJbYMD6dmVjiwpInpVzCfEU=";
      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b14" "tar.gz" "sha256-hfgSrWZKUJNU9CeAyETCrKWKxmCyk9kId8RYSNsKwBM=";
      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "9.1.0" "tar.gz" "sha256-Hp/UBsDJ7iYn9aNx8BL4dzQvf8bzOyVk/NFNbwZjzQ8=";
      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "14.3.0" "tar.gz" "sha256-eoMbY4oNzYXkn3uFUhxecJQD+BxYkGTbWhAWSgAoLyA=";
      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "23.1.0b2" "zip" "sha256-kMmiKVwjPgmsTIxxxDRNXE41jSTJkemnKhO+P/OcPZI=";
      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "9.0.0" "zip" "sha256-Gc+qoTa1EE4/YmJvUSqVG+zZ50wfohvWOe/fLJ/vgb0=";
      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "5.0.0" "zip" "sha256-OLA+/oLCNEzqID/alebQC3rCJ4L6HAtYXNDqLI/z5wI=";
      azure-mgmt-servicefabric = (overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "sha256-3jXhF5EoMsGp6TEJqNJMq5T1VwOpCHsuscWwZVs7GRM=").overridePythonAttrs (attrs: {
        propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ self.msrest self.msrestazure ];
      });
      azure-mgmt-servicelinker = overrideAzureMgmtPackage super.azure-mgmt-servicelinker "1.2.0b2" "tar.gz" "sha256-PpEFMM8ri9OgAa79dGhvPKy5YFfDZZustBUDieQrtZU=";
      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "2.0.0b1" "tar.gz" "sha256-oK2ceBEoQ7gAeG6mye+x8HPzQU9bUNRPVJtRW2GL4xg=";
      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "4.0.0b16" "tar.gz" "sha256-+6QKEROlbXe0oCj4qtB+r4/yCPZD4N+71e5Z1Z/zXV0=";
      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b5" "zip" "sha256-ZFgJflgynRSxo+B+Vso4eX1JheWlDQjfJ9QmupXypMc=";
      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "21.1.0" "tar.gz" "sha256-1tPA6RfJiLye0Eckd9PvP5CIYAnrHZenEZRPg3VjAWI=";
      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b5" "zip" "sha256-5E6Yf1GgNyNVjd+SeFDbhDxnOA6fOAG6oojxtCP4m+k=";
      azure-mgmt-trafficmanager = overrideAzureMgmtPackage super.azure-mgmt-trafficmanager "1.0.0" "zip" "sha256-R0F2HoA0bE7dTLPycTaOqYBj+ATQFeJFwv4EjtK1lqg=";

      azure-storage-common = overrideAzureMgmtPackage super.azure-storage-common "1.4.2" "tar.gz" "sha256-Tsh8dTfUV+yVJS4ORkd+LBzPM3dP/v0F2FRGgssK5AE=";
      azure-synapse-accesscontrol = overrideAzureMgmtPackage super.azure-synapse-accesscontrol "0.5.0" "zip" "sha256-g14ySiByqPgkJGRH8EnIRJO9Q6H2usS5FOeMCQiUuwQ=";
      azure-synapse-spark = overrideAzureMgmtPackage super.azure-synapse-spark "0.2.0" "zip" "sha256-OQ5brhweEIrtN2iP4I5NacdC9t3YUiGIVhhqSs3FMuI=";
    };
  };
in
py
