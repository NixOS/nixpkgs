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
        antlr4 = super.pkgs.antlr4_12;
      });
      azure-mgmt-advisor = overrideAzureMgmtPackage super.azure-mgmt-advisor "9.0.0" "zip" "sha256-/ECLNzFf6EeBtRkST4yxuKwQsvQkHkOdDT4l/WyhjXs=";
      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "4.0.0" "zip" "sha256-AiTjLJ28g80xnrRFLfPUevJgeaxLpuGmvkd3+FskNiw=";
      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "4.0.0" "zip" "sha256-abhavAmuZPxyl1vUNDEXDYx+tdFmdUuYqsXzhF3lfcQ=";
      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "17.0.0" "zip" "sha256-hkM4WVLuwxj4qgXsY8Ya7zu7/v37gKdP0Xbf2EqrsWo=";
      azure-mgmt-billing = overrideAzureMgmtPackage super.azure-mgmt-billing "6.0.0" "zip" "sha256-1PXFpBiKRW/h6zK2xF9VyiBpx0vkHrdpIYQLOfL1wH8=";
      azure-mgmt-botservice = overrideAzureMgmtPackage super.azure-mgmt-botservice "2.0.0b3" "zip" "sha256-XZGQOeMw8usyQ1tl8j57fZ3uqLshomHY9jO/rbpQOvM=";
      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "13.5.0" "zip" "sha256-RK8LGbH4J+nN6gnGBUweZgkqUcMrwe9aVtvZtAvFeBU=";
      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "30.3.0" "tar.gz" "sha256-5Sl4Y0D4YqpqIYp61qW+trn7VYM8XKoIUcwzFNBJO2M=";
      azure-mgmt-containerinstance = overrideAzureMgmtPackage super.azure-mgmt-containerinstance "10.1.0" "zip" "sha256-eNQ3rbKFdPRIyDjtXwH5ztN4GWCYBh3rWdn3AxcEwX4=";
      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "10.1.0" "zip" "sha256-VrX9YfYNvlA8+eNqHCp35BAeQZzQKakZs7ZZKwT8oYc=";
      azure-mgmt-core = overrideAzureMgmtPackage super.azure-mgmt-core "1.3.2" "zip" "sha256-B/Sv6COlXXBLBI1h7f3BMYwFHtWfJEAyEmNQvpXp1QE=";
      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "9.3.0" "tar.gz" "sha256-02DisUN2/auBDhPgE9aUvEvYwoQUQC4NYGD/PQZOl/Y=";
      azure-mgmt-databoxedge = overrideAzureMgmtPackage super.azure-mgmt-databoxedge "1.0.0" "zip" "sha256-BAkAYrwejwDC9FMVo7zrD7OzR57BR01xuINC4TSZsIc=";
      azure-mgmt-datalake-nspkg = overrideAzureMgmtPackage super.azure-mgmt-datalake-nspkg "3.0.1" "zip" "sha256-3rGSukIviz7Ccs5OiHNnlvIW8o6lsD8oMx14S3o/SIA=";
      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "10.0.0" "zip" "sha256-XO5w+X/joJPDy3DCoZDC35Nrdy6UoJ73496x7Rd8nzI=";
      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "8.0.0" "zip" "sha256-QHwtrLM1E/++nKS+Wt216dS64Mt++mE8P31THve/jeg=";
      azure-mgmt-extendedlocation = overrideAzureMgmtPackage super.azure-mgmt-extendedlocation "1.0.0b2" "zip" "sha256-mjfH35T81JQ97jVgElWmZ8P5MwXVxZQv/QJKNLS3T8A=";
      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "9.0.0" "zip" "sha256-QevcacDR+B0l3TBDjBT/9DMfZmOfVYBbkYuWSer/54o=";
      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "1.2.0" "zip" "sha256-XmGIzw+yGYgdaNGZJClFRl531BGsQUH+HESUXGVK6TI=";
      azure-mgmt-iothubprovisioningservices = overrideAzureMgmtPackage super.azure-mgmt-iothubprovisioningservices "1.1.0" "zip" "sha256-04OoJuff93L62G6IozpmHpEaUbHHHD6nKlkMHVoJvJ4=";
      azure-mgmt-managementgroups = overrideAzureMgmtPackage super.azure-mgmt-managementgroups "1.0.0" "zip" "sha256-urm9UyocNFV/Wwq5lQ5DHj8Au5boo85m3w9s4q4ZzXM=";
      azure-mgmt-maps = overrideAzureMgmtPackage super.azure-mgmt-maps "2.0.0" "zip" "sha256-OE4X92potwCk+YhHiUXDqXIXEcBAByWv38tjz4ToXw4=";
      azure-mgmt-marketplaceordering = overrideAzureMgmtPackage super.azure-mgmt-marketplaceordering "1.1.0" "zip" "sha256-aLOB9SpN9ENdrK1al+HFmsTJgfZn3MqPnQRFNBfWCtg=";
      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "5.0.0" "zip" "sha256-eL9KJowxTF7hZJQQQCNJZ7l+rKPFM8wP5vEigt3ZFGE=";
      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "7.0.0" "zip" "sha256-ctRsmmJ4PsTqthm+nRt4/+u9qhZNQG/TA/FjA/NyVrI=";
      azure-mgmt-privatedns = overrideAzureMgmtPackage super.azure-mgmt-privatedns "1.0.0" "zip" "sha256-tg8W5D97KRWCxfV7rhsIMJbYMD6dmVjiwpInpVzCfEU=";
      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "2.5.0" "tar.gz" "sha256-XxowjEhYx5uD/4vY5hGSCSvcarmdbdc5Y2GLHciEurU=";
      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "7.0.0" "tar.gz" "sha256-GuW6x8JGdBedywum4fDAQ8rwbVU9UgQWgHrFqJ6Uz9A=";
      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "1.4.0" "tar.gz" "sha256-BL2a2L2AwJWvs0V+VpSGaS8//AWMy5m6rdAPDJPbrEo=";
      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "14.1.0" "zip" "sha256-LO92Wc2+VvsEKiOjVSHXw2o3D69NQlL58m+YqWl6+ig=";
      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "9.0.0" "zip" "sha256-Gc+qoTa1EE4/YmJvUSqVG+zZ50wfohvWOe/fLJ/vgb0=";
      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "5.0.0" "zip" "sha256-OLA+/oLCNEzqID/alebQC3rCJ4L6HAtYXNDqLI/z5wI=";
      azure-mgmt-servicebus = overrideAzureMgmtPackage super.azure-mgmt-servicebus "8.2.0" "zip" "sha256-i+kgjxQdmnifaNuNIZdU/3gGn9j5OQ6fdkS7laO+nsI=";
      azure-mgmt-servicefabricmanagedclusters = overrideAzureMgmtPackage super.azure-mgmt-servicefabricmanagedclusters "1.0.0" "zip" "sha256-EJyjolHrt92zWg+IKWFKTapwZaFrwTtSyEIu5/mZXOg=";
      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "21.1.0" "tar.gz" "sha256-1tPA6RfJiLye0Eckd9PvP5CIYAnrHZenEZRPg3VjAWI=";
      azure-mgmt-trafficmanager = overrideAzureMgmtPackage super.azure-mgmt-trafficmanager "1.0.0" "zip" "sha256-R0F2HoA0bE7dTLPycTaOqYBj+ATQFeJFwv4EjtK1lqg=";
      azure-synapse-managedprivateendpoints = overrideAzureMgmtPackage super.azure-synapse-managedprivateendpoints "0.4.0" "zip" "sha256-kA6urM/9zQEBKySKfQSQCMkoB7dJ7dHJB0ypJIVUwX4=";

      azure-synapse-spark = overrideAzureMgmtPackage super.azure-synapse-spark "0.2.0" "zip" "sha256-OQ5brhweEIrtN2iP4I5NacdC9t3YUiGIVhhqSs3FMuI=";

      azure-mgmt-appcontainers = overrideAzureMgmtPackage super.azure-mgmt-appcontainers "2.0.0" "zip"
        "sha256-ccdIdvdgTYPWEZCWqkLc8lEuMuAEERvl5B1huJyBkvU=";

      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip"
        "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b4" "zip"
        "sha512-NW2BNj45lKzBmPXWMuBnVEDG2C6xzo9J/QjcC5fczvyhKBIkhugJVOWdPUsSzyGeQYKdqpRWPOl0yBG/eblHQA==";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
        "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b11" "tar.gz"
        "sha256-A7SwklqAhz4Ey9ar1YWythtVZyQ2Y2RUsa27iMc2mxU=";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "3.0.0" "zip"
        "sha256-FJhuVgqNjdRIegP4vUISrAtHvvVle5VQFVITPm4HLEw=";

      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "10.2.0b2" "zip"
        "sha256-QcHY1wCwQyVOEdUi06/wEa4dqJH5Ccd33gJ1Sju0qZA=";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "3.0.0" "tar.gz"
        "sha256-2vIfyYxoo1PsYWMYwOYr4EyNaJmWC+jCy/mRZzrItyI=";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "10.0.0b1" "zip"
        "sha256-1CiZuTXYhIb74eGQZUJHHzovYNnnVd3Ydu1UCy2Bu00=";

      azure-mgmt-kusto = (overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "sha256-nri3eB/UQQ7p4gfNDDmDuvnlhBS1tKGISdCYVuNrrN4=").overridePythonAttrs (attrs: {
        propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ self.msrest self.msrestazure ];
      });

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

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "2.0.0b2" "tar.gz"
        "sha256-05PUV8ouAKq/xhGxVEWIzDop0a7WDTV5mGVSC4sv9P4=";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "4.0.0b12" "tar.gz"
        "sha256-LJx9cdtqpoHl1pPGYodoA50y8NP4ftbXhY7zohsCPH8=";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b5" "zip"
        "sha256-ZFgJflgynRSxo+B+Vso4eX1JheWlDQjfJ9QmupXypMc=";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b5" "zip"
        "sha256-5E6Yf1GgNyNVjd+SeFDbhDxnOA6fOAG6oojxtCP4m+k=";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "10.1.0" "zip"
        "sha256-MZqhSBkwypvEefhoEWEPsBUFidWYD7qAX6edcBDDSSA=";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "10.3.0" "tar.gz"
        "sha256-GDtBZM8YaLjqfv6qmO2tfSpOFKm9l3woGLErdRUM0qI=";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "1.0.0" "zip"
        "sha256-woeix9703hn5LAwxugKGf6xvW433G129qxkoi7RV/Fs=";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "sha256-3jXhF5EoMsGp6TEJqNJMq5T1VwOpCHsuscWwZVs7GRM=";

      azure-mgmt-servicelinker = overrideAzureMgmtPackage super.azure-mgmt-servicelinker "1.2.0b1" "zip"
        "sha256-RK1Q51Q0wAG55oKrFmv65/2AUKl+gRdp27t/EcuMONk=";

      azure-storage-common = overrideAzureMgmtPackage super.azure-storage-common "1.4.2" "tar.gz"
        "sha256-Tsh8dTfUV+yVJS4ORkd+LBzPM3dP/v0F2FRGgssK5AE=";

      azure-keyvault-keys = overrideAzureMgmtPackage super.azure-keyvault-keys "4.9.0b3" "tar.gz"
        "sha256-qoseyf6WqBEG8vPc1hF17K46AWk8Ba8V9KRed4lOlGo=";

      azure-mgmt-datalake-store = overrideAzureMgmtPackage super.azure-mgmt-datalake-store "0.5.0" "zip"
        "sha256-k3bTVJVmHRn4rMVgT2ewvFlJOxg1u8SA+aGVL5ABekw=";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "23.1.0b2" "zip"
        "sha256-kMmiKVwjPgmsTIxxxDRNXE41jSTJkemnKhO+P/OcPZI=";
    };
  };
in
py
