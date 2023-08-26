{ stdenv, python3, fetchPypi, src, version }:

let
  buildAzureCliPackage = with py.pkgs; buildPythonPackage;

  overrideAzureMgmtPackage = package: version: extension: hash:
    # check to make sure overriding is even necessary
    package.overridePythonAttrs (oldAttrs: rec {
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

        propagatedBuildInputs = with self; [
          adal
          antlr4-python3-runtime
          argcomplete
          azure-common
          azure-cli-telemetry
          azure-data-tables
          azure-mgmt-appcontainers
          azure-mgmt-core
          azure-mgmt-resource
          colorama
          cryptography
          distro
          humanfriendly
          jmespath
          knack
          msal
          msal-extensions
          msrest
          msrestazure
          paramiko
          pkginfo
          psutil
          pygments
          pyjwt
          pymysql
          pyopenssl
          pyperclip
          pysocks
          pyyaml
          requests
          six
          tabulate
        ];

        postPatch = ''
          substituteInPlace setup.py \
            --replace "requests[socks]~=2.25.1" "requests[socks]~=2.25" \
            --replace "cryptography>=3.2,<3.4" "cryptography" \
            --replace "msal-extensions>=0.3.1,<0.4" "msal-extensions" \
            --replace "msal[broker]==1.24.0b1" "msal[broker]" \
            --replace "packaging>=20.9,<22.0" "packaging"
        '';
        nativeCheckInputs = with self; [ pytest ];
        doCheck = stdenv.isLinux;
        # ignore tests that does network call, or assume powershell
        checkPhase = ''
          rm azure/{,cli/}__init__.py
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
        version = "1.0.8"; # might be wrong, but doesn't really matter
        inherit src;

        sourceRoot = "${src.name}/src/azure-cli-telemetry";

        propagatedBuildInputs = with super; [
          applicationinsights
          knack
          portalocker
        ];

        nativeCheckInputs = [ py.pkgs.pytest ];
        # ignore flaky test
        checkPhase = ''
          cd azure
          HOME=$TMPDIR pytest -k 'not test_create_telemetry_note_file_from_scratch'
        '';
      };

      antlr4-python3-runtime = super.antlr4-python3-runtime.override (_: {
        antlr4 = super.pkgs.antlr4_9;
      });

      azure-batch = overrideAzureMgmtPackage super.azure-batch "14.0.0" "zip"
        "sha256-FlsembhvghAkxProX7NIadQHqg67DKS5b7JthZwmyTQ=";

      azure-data-tables = overrideAzureMgmtPackage super.azure-data-tables "12.4.0" "zip"
        "sha256-3V/I3pHi+JCO+kxkyn9jz4OzBoqbpCYpjeO1QTnpZlw=";

      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "4.0.0" "zip"
        "sha256-AiTjLJ28g80xnrRFLfPUevJgeaxLpuGmvkd3+FskNiw=";

      azure-mgmt-appcontainers = overrideAzureMgmtPackage super.azure-mgmt-appcontainers "2.0.0" "zip"
        "sha256-ccdIdvdgTYPWEZCWqkLc8lEuMuAEERvl5B1huJyBkvU=";

      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "17.0.0" "zip"
        "sha256-hkM4WVLuwxj4qgXsY8Ya7zu7/v37gKdP0Xbf2EqrsWo=";

      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip"
        "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";

      azure-mgmt-billing = overrideAzureMgmtPackage super.azure-mgmt-billing "6.0.0" "zip"
        "sha256-1PXFpBiKRW/h6zK2xF9VyiBpx0vkHrdpIYQLOfL1wH8=";

      azure-mgmt-botservice = overrideAzureMgmtPackage super.azure-mgmt-botservice "2.0.0b3" "zip"
        "sha256-XZGQOeMw8usyQ1tl8j57fZ3uqLshomHY9jO/rbpQOvM=";

      azure-mgmt-extendedlocation = overrideAzureMgmtPackage super.azure-mgmt-extendedlocation "1.0.0b2" "zip"
        "sha256-mjfH35T81JQ97jVgElWmZ8P5MwXVxZQv/QJKNLS3T8A=";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b4" "zip"
        "sha512-NW2BNj45lKzBmPXWMuBnVEDG2C6xzo9J/QjcC5fczvyhKBIkhugJVOWdPUsSzyGeQYKdqpRWPOl0yBG/eblHQA==";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b10" "zip"
        "sha256-sM8oZdhv+5WCd4RnMtEmCikTBmzGsap5heKzSbHbRPI=";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "2.4.0" "zip"
        "sha256-2JeOvtNxx6Z3AY4GI9fBRKbMcYVHsbrhk8C+5t5eelk=";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "6.0.0" "zip"
        "sha256-lIEYi/jvF9pYbnH+clUzfU0fExlY+dZojIyZRtTLQh8=";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "3.0.0" "zip"
        "sha256-FJhuVgqNjdRIegP4vUISrAtHvvVle5VQFVITPm4HLEw=";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "13.5.0" "zip"
        "sha512-bUFY0+JipVihatMib0Giv7THnv4rRAbT36PhP+5tcsVlBVLmCYqjyp0iWnTfSbvRiljKOjbm3w+xeC0gL/IE7w==";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "30.0.0" "zip"
        "sha256-cyD7r8OSdwsD7QK2h2AYXmCUVS7ZjX/V6nchClpRPHg=";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "sha256-moWonzDyJNJhdJviC0YWoOuJSFhvfw8gVzuOoy8mUYk=";

      azure-mgmt-containerinstance = overrideAzureMgmtPackage super.azure-mgmt-containerinstance "10.1.0" "zip"
        "sha256-eNQ3rbKFdPRIyDjtXwH5ztN4GWCYBh3rWdn3AxcEwX4=";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "25.0.0" "zip"
        "sha256-je7O92bklsbIlfsTUF2TXUqztAZxn8ep4ezCUHeLuhE=";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "9.2.0" "zip"
        "sha256-PAaBkR77Ho2YI5I+lmazR/8vxEZWpbvM427yRu1ET0k=";

      azure-mgmt-databoxedge = overrideAzureMgmtPackage super.azure-mgmt-databoxedge "1.0.0" "zip"
        "sha256-BAkAYrwejwDC9FMVo7zrD7OzR57BR01xuINC4TSZsIc=";

      azure-mgmt-deploymentmanager = overrideAzureMgmtPackage super.azure-mgmt-deploymentmanager "0.2.0" "zip"
        "sha256-RuNCInmT/JrKsd2kLy61ZrUiqMlFq50O6lYna0b21zA=";

      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "10.2.0b2" "zip"
        "sha256-QcHY1wCwQyVOEdUi06/wEa4dqJH5Ccd33gJ1Sju0qZA=";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "1.2.0" "zip"
        "sha256-XmGIzw+yGYgdaNGZJClFRl531BGsQUH+HESUXGVK6TI=";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "2.3.0" "zip"
        "sha256-ml+koj52l5o0toAcnsGtsw0tGnO5F/LKq56ovzdmx/A=";

      azure-mgmt-iothubprovisioningservices = overrideAzureMgmtPackage super.azure-mgmt-iothubprovisioningservices "1.1.0" "zip"
        "sha256-04OoJuff93L62G6IozpmHpEaUbHHHD6nKlkMHVoJvJ4=";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "10.0.0b1" "zip"
        "sha256-1CiZuTXYhIb74eGQZUJHHzovYNnnVd3Ydu1UCy2Bu00=";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "sha256-nri3eB/UQQ7p4gfNDDmDuvnlhBS1tKGISdCYVuNrrN4=";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip"
        "sha256-WVScTEBo8mRmsQl7V0qOUJn7LNbIvgoAOVsG07KeJ40=r";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "10.0.0" "zip"
        "sha256-9+cXsY8Qr5ds9lYw39duWdcqm6QUTedQbjn8x6zJoyE=";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "8.0.0" "zip"
        "sha256-QHwtrLM1E/++nKS+Wt216dS64Mt++mE8P31THve/jeg=";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "13.0.0b4" "zip"
        "sha256-Jm1t7v5vyFjNNM/evVaEI9sXJKNwJk6XAXuJSRSnKHk=";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "21.0.1" "zip"
        "sha256-7PduPg0JK4f/3q/b5pq58TjqVk+Iu+vxa+aJKDnScy8=";

      azure-mgmt-maps = overrideAzureMgmtPackage super.azure-mgmt-maps "2.0.0" "zip"
        "sha256-OE4X92potwCk+YhHiUXDqXIXEcBAByWv38tjz4ToXw4=";

      azure-mgmt-managedservices = overrideAzureMgmtPackage super.azure-mgmt-managedservices "1.0.0" "zip"
        "sha256-/tg5n8Z3Oq2jfB0ElqRvWUENd8lJTQyllnxTHDN2rRk=";

      azure-mgmt-managementgroups = overrideAzureMgmtPackage super.azure-mgmt-managementgroups "1.0.0" "zip"
        "sha256-urm9UyocNFV/Wwq5lQ5DHj8Au5boo85m3w9s4q4ZzXM=";

      azure-mgmt-marketplaceordering = overrideAzureMgmtPackage super.azure-mgmt-marketplaceordering "1.1.0" "zip"
        "sha256-aLOB9SpN9ENdrK1al+HFmsTJgfZn3MqPnQRFNBfWCtg=";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "9.0.0" "zip"
        "sha256-TI7l8sSQ2QUgPqiE3Cu/F67Wna+KHbQS3fuIjOb95ZM=";

      azure-mgmt-msi = super.azure-mgmt-msi.overridePythonAttrs (old: rec {
        version = "7.0.0";
        src = old.src.override {
          inherit version;
          hash = "sha256-ctRsmmJ4PsTqthm+nRt4/+u9qhZNQG/TA/FjA/NyVrI=";
        };
      });

      azure-mgmt-privatedns = overrideAzureMgmtPackage super.azure-mgmt-privatedns "1.0.0" "zip"
        "sha256-tg8W5D97KRWCxfV7rhsIMJbYMD6dmVjiwpInpVzCfEU=";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "7.0.0" "zip"
        "sha256-WvyNgfiliEt6qawqy8Le8eifhxusMkoZbf6YcyY1SBA=";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "1.2.0" "zip"
        "sha256-ZU4mKTzny9tsKDrFSU+lll5v6oDivYJlXDriWJLAYec=";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "14.1.0" "zip"
        "sha256-LO92Wc2+VvsEKiOjVSHXw2o3D69NQlL58m+YqWl6+ig=";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "2.0.0" "zip"
        "sha256-5vXdXiRubnzPk4uTFeNHR6rwiHSGbeUREX9eW1pqC3E=";

      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "9.0.0" "zip"
        "sha256-Gc+qoTa1EE4/YmJvUSqVG+zZ50wfohvWOe/fLJ/vgb0=";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "5.0.0" "zip"
        "sha512-wMI55Ou96rzUEZIeTDmMfR4KIz3tG98z6A6teJanGPyNgte9tGa0/+2ge0yX10iwRKZyZZPNTReCkcd+IOkS+A==";

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "1.1.0" "zip"
        "sha256-lUNIDyP5W+8aIX7manfMqaO2IJJm/+2O+Buv+Bh4EZE=";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "4.0.0b10" "zip"
        "sha256-QHvbO6Toh5QflMIaNYmxXBy0Dmw++RVdim3HEDtLBrQ=";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b5" "zip"
        "sha256-ZFgJflgynRSxo+B+Vso4eX1JheWlDQjfJ9QmupXypMc=";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b5" "zip"
        "sha256-5E6Yf1GgNyNVjd+SeFDbhDxnOA6fOAG6oojxtCP4m+k=";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "10.0.0" "zip"
        "sha256-XO5w+X/joJPDy3DCoZDC35Nrdy6UoJ73496x7Rd8nzI=";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "sha256-2fmHzymYuKNU8zGypxCCwEkZPx4c00WBLhS5uCE2Wss=";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "10.1.0" "zip"
        "sha256-MZqhSBkwypvEefhoEWEPsBUFidWYD7qAX6edcBDDSSA=";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "10.2.2" "zip"
        "sha256-LG6oMTZepgT87KdJrwCpc4ZYEclUsEAHUitZrxFCkL4=";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
        "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "10.1.0" "zip"
        "sha256-VrX9YfYNvlA8+eNqHCp35BAeQZzQKakZs7ZZKwT8oYc=";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "5.0.0" "zip"
        "sha256-eL9KJowxTF7hZJQQQCNJZ7l+rKPFM8wP5vEigt3ZFGE=";

      azure-mgmt-advisor = overrideAzureMgmtPackage super.azure-mgmt-advisor "9.0.0" "zip"
        "sha256-/ECLNzFf6EeBtRkST4yxuKwQsvQkHkOdDT4l/WyhjXs=";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "1.0.0" "zip"
        "sha256-woeix9703hn5LAwxugKGf6xvW433G129qxkoi7RV/Fs=";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "3.0.0" "zip"
        "sha256-Cl1/aDvzNyI2uEHNvUZ39rCO185BuZnD5kTUKGJSBX0=";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "21.0.0" "zip"
        "sha256-brE+7s+JGVsrX0e+Bnnj8niI79e9ITLux+vLznXLE3c=";

      azure-mgmt-servicebus = overrideAzureMgmtPackage super.azure-mgmt-servicebus "8.2.0" "zip"
        "sha256-i+kgjxQdmnifaNuNIZdU/3gGn9j5OQ6fdkS7laO+nsI=";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "sha256-3jXhF5EoMsGp6TEJqNJMq5T1VwOpCHsuscWwZVs7GRM=";

      azure-mgmt-servicelinker = overrideAzureMgmtPackage super.azure-mgmt-servicelinker "1.2.0b1" "zip"
        "sha256-RK1Q51Q0wAG55oKrFmv65/2AUKl+gRdp27t/EcuMONk=";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "9.0.0" "zip"
        "sha256-QevcacDR+B0l3TBDjBT/9DMfZmOfVYBbkYuWSer/54o=";

      azure-multiapi-storage = overrideAzureMgmtPackage super.azure-multiapi-storage "1.2.0" "tar.gz"
        "sha256-CQuoWHeh0EMitTRsvifotrTwpWd/Q9LWWD7jZ2w9r8I=";

      azure-appconfiguration = super.azure-appconfiguration.overrideAttrs (oldAttrs: rec {
        version = "1.1.1";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-uDzSy2PZMiXehOJ6u/wFkhL43id2b0xY3Tq7g53/C+Q=";
          extension = "zip";
        };
      });

      azure-graphrbac = super.azure-graphrbac.overrideAttrs (oldAttrs: rec {
        version = "0.60.0";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-0Lti2L+OGWuQPzlxukr6RI5P4U6DlOv83ZQdhNYuyv4=";
          extension = "zip";
        };
      });

      azure-storage-blob = super.azure-storage-blob.overrideAttrs (oldAttrs: rec {
        version = "1.5.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-8YeoeOehkfTgmBWZBPcrQUbPcOGquvZISrS6cvxvJSw=";
        };
      });

      azure-storage-common = super.azure-storage-common.overrideAttrs (oldAttrs: rec {
        version = "1.4.2";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-Tsh8dTfUV+yVJS4ORkd+LBzPM3dP/v0F2FRGgssK5AE=";
        };
      });

      azure-synapse-artifacts = super.azure-synapse-artifacts.overrideAttrs (oldAttrs: rec {
        version = "0.15.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-XxryuN5HVuY9h6ioSEv9nwzkK6wYLupvFOCJqX82eWE=";
          extension = "zip";
        };
        propagatedBuildInputs = with super; oldAttrs.propagatedBuildInputs ++ [
          azure-mgmt-core
        ];
      });

      azure-synapse-accesscontrol = super.azure-synapse-accesscontrol.overrideAttrs (oldAttrs: rec {
        version = "0.5.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-g14ySiByqPgkJGRH8EnIRJO9Q6H2usS5FOeMCQiUuwQ=";
          extension = "zip";
        };
      });

      azure-synapse-managedprivateendpoints = super.azure-synapse-managedprivateendpoints.overrideAttrs (oldAttrs: rec {
        version = "0.4.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-kA6urM/9zQEBKySKfQSQCMkoB7dJ7dHJB0ypJIVUwX4=";
          extension = "zip";
        };
      });

      azure-synapse-spark = super.azure-synapse-spark.overrideAttrs (oldAttrs: rec {
        version = "0.2.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-OQ5brhweEIrtN2iP4I5NacdC9t3YUiGIVhhqSs3FMuI=";
          extension = "zip";
        };
      });

      azure-keyvault = super.azure-keyvault.overrideAttrs (oldAttrs: rec {
        version = "1.1.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          hash = "sha256-N6jl83brWjBPzQZtQUtdk7mH5o+SErDEHvo31Cmq3Uk=";
        };

        propagatedBuildInputs = with self; [
          azure-common
          azure-nspkg
          msrest
          msrestazure
          cryptography
        ];
        pythonNamespaces = [ "azure" ];
        pythonImportsCheck = [ ];
      });

      azure-keyvault-administration = super.azure-keyvault-administration.overridePythonAttrs (oldAttrs: rec {
        version = "4.3.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          hash = "sha256-PuKjui0OP0ODNErjbjJ90hOgee97JDrVT2sh+MufxWY=";
        };
      });

      azure-keyvault-keys = super.azure-keyvault-keys.overridePythonAttrs (oldAttrs: rec {
        version = "4.8.0b2";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          hash = "sha256-VUwQJAwpZIQ8fzBUjUX0ui2yaVkDK7p0fwmnz373XbY=";
        };
      });


      # part of azure.mgmt.datalake namespace
      azure-mgmt-datalake-analytics = super.azure-mgmt-datalake-analytics.overrideAttrs (oldAttrs: rec {
        version = "0.2.1";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-THlg0JT1hH2aRWwYuKPI5gxCjjCAo5BfHJQ9gbpjUaQ=";
          extension = "zip";
        };

        preBuild = ''
          rm azure_bdist_wheel.py
          substituteInPlace setup.cfg \
            --replace "azure-namespace-package = azure-mgmt-datalake-nspkg" ""
        '';
      });

      azure-mgmt-datalake-store = super.azure-mgmt-datalake-store.overrideAttrs (oldAttrs: rec {
        version = "0.5.0";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-k3bTVJVmHRn4rMVgT2ewvFlJOxg1u8SA+aGVL5ABekw=";
          extension = "zip";
        };

        preBuild = ''
          rm azure_bdist_wheel.py
          substituteInPlace setup.cfg \
            --replace "azure-namespace-package = azure-mgmt-datalake-nspkg" ""
        '';
      });

      adal = super.adal.overridePythonAttrs (oldAttrs: rec {
        version = "1.2.7";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-109FuBMXRU2W6YL9HFDm+1yZrCIjcorqh2RDOjn1ZvE=";
        };

        # sdist doesn't provide tests
        doCheck = false;
      });

      msal = super.msal.overridePythonAttrs (oldAttrs: rec {
        version = "1.24.0b1";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-ze5CqX+m8XH4NUECL2SgNT9EXV4wS/0DgO5XMDHo/Uo=";
        };
      });

      semver = super.semver.overridePythonAttrs (oldAttrs: rec {
        version = "2.13.0";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-+g/ici7hw/V+rEeIIMOlri9iSvgmTL35AAyYD/f3Xj8=";
        };
      });

      jsondiff = super.jsondiff.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0";

        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-J5WETvB17IorjThcTVn16kiwjnGA/OPLJ4e+DbALH7Q=";
        };
      });

      knack = super.knack.overridePythonAttrs (oldAttrs: rec {
        version = "0.11.0";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-62VoAB6RELGzIJQUMcUQM9EEzJjNoiVKXCsJulaf1JQ=";
        };
      });

      argcomplete = super.argcomplete.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.1";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-bExWPxTwFECq/6Pq4TRBxdsjV7Xuxjmr58CxUzRiff8=";
        };
      });

      sshtunnel = super.sshtunnel.overridePythonAttrs (oldAttrs: rec {
        name = "sshtunnel-${version}";
        version = "0.1.5";

        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-yBP9zajoHDk2/+rEfLac+y0fXnetDeZWxtq1au69kkk=";
        };
      });

      websocket-client = super.websocket-client.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.1";

        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-YninUGU5VBgoP4h958O+r7OqaNraXKy+SyFOjSbaSZs=";
        };
      });

      azure-mgmt-resource = super.azure-mgmt-resource.overridePythonAttrs (oldAttrs: rec {
        version = "23.1.0b2";

        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-kMmiKVwjPgmsTIxxxDRNXE41jSTJkemnKhO+P/OcPZI=";
        };
      });
    };
  };
in
py
