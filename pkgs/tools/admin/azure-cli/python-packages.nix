{ stdenv
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

        patches = [
          (fetchpatch {
            name = "fix-python311.patch";
            url = "https://github.com/Azure/azure-cli/commit/a5198b578b17de934e15b1c92e369e45323e9658.patch";
            hash = "sha256-qbyKF6Vvtz8QwY78sG7ptTVcbM2IR+phntOKqsrWetE=";
            stripLen = 2;
            includes = [
              "azure/cli/core/tests/test_command_registration.py"
              "azure/cli/core/tests/test_help.py"
              "azure/cli/core/tests/test_parser.py"
            ];
          })
        ];

        sourceRoot = "${src.name}/src/azure-cli-core";

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

      antlr4-python3-runtime = super.antlr4-python3-runtime.override (_: {
        antlr4 = super.pkgs.antlr4_9;
      });

      azure-mgmt-appcontainers = overrideAzureMgmtPackage super.azure-mgmt-appcontainers "2.0.0" "zip"
        "sha256-ccdIdvdgTYPWEZCWqkLc8lEuMuAEERvl5B1huJyBkvU=";

      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip"
        "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b4" "zip"
        "sha512-NW2BNj45lKzBmPXWMuBnVEDG2C6xzo9J/QjcC5fczvyhKBIkhugJVOWdPUsSzyGeQYKdqpRWPOl0yBG/eblHQA==";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
        "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b10" "zip"
        "sha256-sM8oZdhv+5WCd4RnMtEmCikTBmzGsap5heKzSbHbRPI=";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "3.0.0" "zip"
        "sha256-FJhuVgqNjdRIegP4vUISrAtHvvVle5VQFVITPm4HLEw=";

      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "10.2.0b2" "zip"
        "sha256-QcHY1wCwQyVOEdUi06/wEa4dqJH5Ccd33gJ1Sju0qZA=";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "2.3.0" "zip"
        "sha256-ml+koj52l5o0toAcnsGtsw0tGnO5F/LKq56ovzdmx/A=";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "10.0.0b1" "zip"
        "sha256-1CiZuTXYhIb74eGQZUJHHzovYNnnVd3Ydu1UCy2Bu00=";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "sha256-nri3eB/UQQ7p4gfNDDmDuvnlhBS1tKGISdCYVuNrrN4=";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip"
        "sha256-WVScTEBo8mRmsQl7V0qOUJn7LNbIvgoAOVsG07KeJ40=r";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "13.0.0b4" "zip"
        "sha256-Jm1t7v5vyFjNNM/evVaEI9sXJKNwJk6XAXuJSRSnKHk=";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "9.0.0" "zip"
        "sha256-TI7l8sSQ2QUgPqiE3Cu/F67Wna+KHbQS3fuIjOb95ZM=";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "7.0.0" "zip"
        "sha256-WvyNgfiliEt6qawqy8Le8eifhxusMkoZbf6YcyY1SBA=";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "10.1.0" "zip"
        "sha256-eJiWTOCk2C79Jotku9bKlu3vU6H8004hWrX+h76MjQM=";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "4.0.0b12" "tar.gz"
        "sha256-LJx9cdtqpoHl1pPGYodoA50y8NP4ftbXhY7zohsCPH8=";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b5" "zip"
        "sha256-ZFgJflgynRSxo+B+Vso4eX1JheWlDQjfJ9QmupXypMc=";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b5" "zip"
        "sha256-5E6Yf1GgNyNVjd+SeFDbhDxnOA6fOAG6oojxtCP4m+k=";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "10.1.0" "zip"
        "sha256-MZqhSBkwypvEefhoEWEPsBUFidWYD7qAX6edcBDDSSA=";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "10.2.3" "zip"
        "sha256-JDM6F0ToMpUeBlLULih17TLzCbrNdxrGrcq5oIfsybU=";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "1.0.0" "zip"
        "sha256-woeix9703hn5LAwxugKGf6xvW433G129qxkoi7RV/Fs=";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "sha256-3jXhF5EoMsGp6TEJqNJMq5T1VwOpCHsuscWwZVs7GRM=";

      azure-mgmt-servicelinker = overrideAzureMgmtPackage super.azure-mgmt-servicelinker "1.2.0b1" "zip"
        "sha256-RK1Q51Q0wAG55oKrFmv65/2AUKl+gRdp27t/EcuMONk=";

      azure-storage-common = overrideAzureMgmtPackage super.azure-storage-common "1.4.2" "tar.gz"
        "sha256-Tsh8dTfUV+yVJS4ORkd+LBzPM3dP/v0F2FRGgssK5AE=";

      azure-keyvault-keys = overrideAzureMgmtPackage super.azure-keyvault-keys "4.8.0b2" "zip"
        "sha256-VUwQJAwpZIQ8fzBUjUX0ui2yaVkDK7p0fwmnz373XbY=";

      azure-mgmt-datalake-store = overrideAzureMgmtPackage super.azure-mgmt-datalake-store "0.5.0" "zip"
        "sha256-k3bTVJVmHRn4rMVgT2ewvFlJOxg1u8SA+aGVL5ABekw=";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "23.1.0b2" "zip"
        "sha256-kMmiKVwjPgmsTIxxxDRNXE41jSTJkemnKhO+P/OcPZI=";
    };
  };
in
py
