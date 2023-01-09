{ stdenv, python3, lib, src, version }:

let
  buildAzureCliPackage = with py.pkgs; buildPythonPackage;

  overrideAzureMgmtPackage = package: version: extension: sha256:
    # check to make sure overriding is even necessary
    package.overrideAttrs(oldAttrs: rec {
      inherit version;

      src = py.pkgs.fetchPypi {
        inherit (oldAttrs) pname;
        inherit version sha256 extension;
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
          azure-mgmt-core
          azure-mgmt-resource
          colorama
          cryptography
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
            --replace "msal-extensions>=0.3.1,<0.4" "msal-extensions"
        '';
        checkInputs = with self; [ pytest ];
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

        checkInputs = [ py.pkgs.pytest ];
        # ignore flaky test
        checkPhase = ''
          cd azure
          HOME=$TMPDIR pytest -k 'not test_create_telemetry_note_file_from_scratch'
        '';
      };

      antlr4-python3-runtime = super.antlr4-python3-runtime.override(_: {
        antlr4 = super.pkgs.antlr4_9;
      });

      azure-batch = overrideAzureMgmtPackage super.azure-batch "13.0.0" "zip"
        "sha256-6Sld5wQE0nbtoN0iU9djl0Oavl2PGMH8oZnEm41q4wo=";

      azure-data-tables = overrideAzureMgmtPackage super.azure-data-tables "12.4.0" "zip"
        "sha256-3V/I3pHi+JCO+kxkyn9jz4OzBoqbpCYpjeO1QTnpZlw=";

      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "3.0.0" "zip"
        "9262f54ed387eb083d8dae66d32a8df35647319b902bd498cdc376f50a12d154";

      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "17.0.0" "zip"
        "sha256-hkM4WVLuwxj4qgXsY8Ya7zu7/v37gKdP0Xbf2EqrsWo=";

      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip"
        "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";

      azure-mgmt-billing = overrideAzureMgmtPackage super.azure-mgmt-billing "6.0.0" "zip"
        "d4f5c5a4188a456fe1eb32b6c45f55ca2069c74be41eb76921840b39f2f5c07f";

      azure-mgmt-botservice = overrideAzureMgmtPackage super.azure-mgmt-botservice "2.0.0b3" "zip"
        "sha256-XZGQOeMw8usyQ1tl8j57fZ3uqLshomHY9jO/rbpQOvM=";

      azure-mgmt-extendedlocation = overrideAzureMgmtPackage super.azure-mgmt-extendedlocation "1.0.0b2" "zip"
        "sha256-mjfH35T81JQ97jVgElWmZ8P5MwXVxZQv/QJKNLS3T8A=";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b2" "zip"
        "sha256-e+I5MdbbX7WhxHCj1Ery3z2WUrJtpWGD1bhLbqReb58=";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b5" "zip"
        "sha256-YaokPCleAiwM893QFU+tbhL+8UngvGGshdeEBDCVTu4=";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "2.1.0" "zip"
        "sha256-2DeOemVpkjeI/hUdG04IuHU2h3cmk3oG4kr1wIDvdbM=";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "5.1.0b1" "zip"
        "sha256-4djPfDzj9ql5WFn5fafLZWRKbofvb1Y7j05S77ly75s=";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "21.1.0b1" "zip"
        "sha256-oiC5k+Mg9KJn940jMxG4AB9Pom+t/DWRA5KRv8HO0HI=";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "2.2.0" "zip"
        "sha256-R2COS22pCtFp3oV98LLn/X2LkPOVUCasEONhFIhEdBQ=";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "13.3.0" "zip"
        "sha256-v1pTNPH0ujRm4VMt95Uw6d07lF8bgM3XIa3NJIbNLFI=";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "29.0.0" "zip"
        "sha256-wkRmH/3MMxeTZr7KQMZQbjPHs2GSxAjJFZlSp75pUPI=";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerinstance = overrideAzureMgmtPackage super.azure-mgmt-containerinstance "9.1.0" "zip"
        "sha256-IhZLDFkTize8SLptR2v2NRUrxCjctCC1IaFLjCXHl60=";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "21.1.0" "zip"
        "sha256-5EOythXO7spLzzlqDWrwcdkkJAMH9W8OBv96rYaWxAY=";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "8.0.0" "zip"
        "sha256-/6ySVfCjr1YiiZIZJElrd1EfirV+TJvE/FvKs7UhoKo=";

      azure-mgmt-databoxedge = overrideAzureMgmtPackage super.azure-mgmt-databoxedge "1.0.0" "zip"
        "04090062bc1e8f00c2f45315a3bceb0fb3b3479ec1474d71b88342e13499b087";

      azure-mgmt-deploymentmanager = overrideAzureMgmtPackage super.azure-mgmt-deploymentmanager "0.2.0" "zip"
        "0c6pyr36n9snx879vas5r6l25db6nlp2z96xn759mz4kg4i45qs6";

      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "10.2.0b2" "zip"
        "sha256-QcHY1wCwQyVOEdUi06/wEa4dqJH5Ccd33gJ1Sju0qZA=";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "1.1.0" "zip"
        "sha256-2EWfTsl5y3Sw4P8d5X7TKxYmO4PagUTNv/SFKdjY2Ss=";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "2.3.0" "zip"
        "sha256-ml+koj52l5o0toAcnsGtsw0tGnO5F/LKq56ovzdmx/A=";

      azure-mgmt-iothubprovisioningservices = overrideAzureMgmtPackage super.azure-mgmt-iothubprovisioningservices "1.1.0" "zip"
        "sha256-04OoJuff93L62G6IozpmHpEaUbHHHD6nKlkMHVoJvJ4=";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "10.0.0b1" "zip"
        "sha256-1CiZuTXYhIb74eGQZUJHHzovYNnnVd3Ydu1UCy2Bu00=";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip"
        "1397ksrd61jv7400mgn8sqngp6ahir55fyq9n5k69wk88169qm2r";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "9.0.1" "zip"
        "sha256-PYRMOWaJUXrRgqW3+pLBY+L6HvU1WlPvaatFe4O7RY8=";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "8.0.0" "zip"
        "407c2dacb33513ffbe9ca4be5addb5e9d4bae0cb7efa613c3f7d531ef7bf8de8";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "13.0.0b4" "zip"
        "sha256-Jm1t7v5vyFjNNM/evVaEI9sXJKNwJk6XAXuJSRSnKHk=";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "21.0.1" "zip"
        "sha256-7PduPg0JK4f/3q/b5pq58TjqVk+Iu+vxa+aJKDnScy8=";

      azure-mgmt-maps = overrideAzureMgmtPackage super.azure-mgmt-maps "2.0.0" "zip"
        "384e17f76a68b700a4f988478945c3a9721711c0400725afdfcb63cf84e85f0e";

      azure-mgmt-managedservices = overrideAzureMgmtPackage super.azure-mgmt-managedservices "1.0.0" "zip"
        "sha256-/tg5n8Z3Oq2jfB0ElqRvWUENd8lJTQyllnxTHDN2rRk=";

      azure-mgmt-managementgroups = overrideAzureMgmtPackage super.azure-mgmt-managementgroups "1.0.0" "zip"
        "bab9bd532a1c34557f5b0ab9950e431e3f00bb96e8a3ce66df0f6ce2ae19cd73";

      azure-mgmt-marketplaceordering = overrideAzureMgmtPackage super.azure-mgmt-marketplaceordering "1.1.0" "zip"
        "68b381f52a4df4435dacad5a97e1c59ac4c981f667dcca8f9d04453417d60ad8";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "9.0.0" "zip"
        "sha256-TI7l8sSQ2QUgPqiE3Cu/F67Wna+KHbQS3fuIjOb95ZM=";

      azure-mgmt-msi = super.azure-mgmt-msi.overridePythonAttrs (old: rec {
        version = "6.1.0";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-lS8da3Al1z1pMLDBf6ZtWc1UFUVgkN1qpKTxt4VXdlQ=";
        };
      });

      azure-mgmt-privatedns = overrideAzureMgmtPackage super.azure-mgmt-privatedns "1.0.0" "zip"
        "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "7.0.0" "zip"
        "sha256-WvyNgfiliEt6qawqy8Le8eifhxusMkoZbf6YcyY1SBA=";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "1.1.0" "zip"
        "sha256-Tq8h3fvajxIG2QjtCyHCQDE2deBDioxLLaQQek/O24U=";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "14.1.0" "zip"
        "sha256-LO92Wc2+VvsEKiOjVSHXw2o3D69NQlL58m+YqWl6+ig=";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "2.0.0" "zip"
        "sha256-5vXdXiRubnzPk4uTFeNHR6rwiHSGbeUREX9eW1pqC3E=";

      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "8.0.0" "zip"
        "a96d50c88507233a293e757202deead980c67808f432b8e897c4df1ca088da7e";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "3.0.0" "zip"
        "sha256-vLp874V/awKi2Yr+sH+YcbFij6M9iGGrE4fnMufbP4Q=";

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "1.1.0" "zip"
        "sha256-lUNIDyP5W+8aIX7manfMqaO2IJJm/+2O+Buv+Bh4EZE=";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "4.0.0b6" "zip"
        "sha256-1/0VGMW9yZsilJ0yNjhFzVO7WbJlB4yJmDL/RxpQLKc=";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b4" "zip"
        "sha256-IB/ihVFm8WrJ2ZZfALp167Sq4u0cvIq1hllNriJxaz0=";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b5" "zip"
        "sha256-5E6Yf1GgNyNVjd+SeFDbhDxnOA6fOAG6oojxtCP4m+k=";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "10.0.0" "zip"
        "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "10.1.0" "zip"
        "sha256-MZqhSBkwypvEefhoEWEPsBUFidWYD7qAX6edcBDDSSA=";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "10.1.0" "zip"
        "sha256-DpO+6FvsNwjjcz2ImhHpColHVNpPUMgCtEMrfUzfAaA=";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
        "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "10.0.0" "zip"
        "sha256-HjejK28Em5AeoQ20o4fucnXTlAwADF/SEpVfHn9anZk=";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "5.0.0" "zip"
        "sha256-eL9KJowxTF7hZJQQQCNJZ7l+rKPFM8wP5vEigt3ZFGE=";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "9.0.0" "zip"
        "fc408b37315fe84781b519124f8cb1b8ac10b2f4241e439d0d3e25fd6ca18d7b";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "1.0.0" "zip"
        "c287a2c7def4de19f92c0c31ba02867fac6f5b8df71b5dbdab19288bb455fc5b";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.61.0" "zip"
        "0xfvx2dvfj3fbz4ngn860ipi4v6gxqajyjc8x92r8knhmniyxk7m";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "21.0.0" "zip"
        "sha256-brE+7s+JGVsrX0e+Bnnj8niI79e9ITLux+vLznXLE3c=";

      azure-mgmt-servicebus = overrideAzureMgmtPackage super.azure-mgmt-servicebus "8.1.0" "zip"
        "sha256-R8Narn7eC7j59tDjsgbk9lF0PcOgOwSnzoMp3Qu0rmg=";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "de35e117912832c1a9e93109a8d24cab94f55703a9087b2eb1c5b0655b3b1913";

      azure-mgmt-servicelinker = overrideAzureMgmtPackage super.azure-mgmt-servicelinker "1.2.0b1" "zip"
        "sha256-RK1Q51Q0wAG55oKrFmv65/2AUKl+gRdp27t/EcuMONk=";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "9.0.0" "zip"
        "41ebdc69c0d1f81d25dd30438c14fff4331f66639f55805b918b9649eaffe78a";

      azure-multiapi-storage = overrideAzureMgmtPackage super.azure-multiapi-storage "1.0.0" "tar.gz"
        "sha256-x5v3e3/poSm+JMt0SWI1lcM6YAUcP+o2Sn8TluXOyIg=";

      azure-appconfiguration = super.azure-appconfiguration.overrideAttrs(oldAttrs: rec {
        version = "1.1.1";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-uDzSy2PZMiXehOJ6u/wFkhL43id2b0xY3Tq7g53/C+Q=";
          extension = "zip";
        };
      });

      azure-graphrbac = super.azure-graphrbac.overrideAttrs(oldAttrs: rec {
        version = "0.60.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1zna5vb887clvpyfp5439vhlz3j4z95blw9r7y86n6cfpzc65fyh";
          extension = "zip";
        };
      });

      azure-storage-blob = super.azure-storage-blob.overrideAttrs(oldAttrs: rec {
        version = "1.5.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0b15dzy75fml994gdfmaw5qcyij15gvh968mk3hg94d1wxwai1zi";
        };
      });

      azure-storage-common = super.azure-storage-common.overrideAttrs(oldAttrs: rec {
        version = "1.4.2";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "00g41b5q4ijlv02zvzjgfwrwy71cgr3lc3if4nayqmyl6xsprj2f";
        };
      });

      azure-synapse-artifacts = super.azure-synapse-artifacts.overrideAttrs(oldAttrs: rec {
        version = "0.14.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-Q1gGq7EZ/JvYjD7y0mp3kEy15QKZI84UQTdlIBoQLMs=";
          extension = "zip";
        };
        propagatedBuildInputs = with super; oldAttrs.propagatedBuildInputs ++ [
          azure-mgmt-core
        ];
      });

      azure-synapse-accesscontrol = super.azure-synapse-accesscontrol.overrideAttrs(oldAttrs: rec {
        version = "0.5.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-g14ySiByqPgkJGRH8EnIRJO9Q6H2usS5FOeMCQiUuwQ=";
          extension = "zip";
        };
      });

      azure-synapse-managedprivateendpoints = super.azure-synapse-managedprivateendpoints.overrideAttrs(oldAttrs: rec {
        version = "0.3.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-fN1IuZ9fjxgRZv6qh9gg6v6KYpnKlXfnoLqfZCDXoRY=";
          extension = "zip";
        };
      });

      azure-synapse-spark = super.azure-synapse-spark.overrideAttrs(oldAttrs: rec {
        version = "0.2.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1qijqp6llshqas422lnqvpv45iv99n7f13v86znql40y3jp5n3ir";
          extension = "zip";
        };
      });

      azure-keyvault = super.azure-keyvault.overrideAttrs(oldAttrs: rec {
        version = "1.1.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          sha256 = "0jfxm8lx8dzs3v2b04ljizk8gfckbm5l2v86rm7k0npbfvryba1p";
        };

        propagatedBuildInputs = with self; [
          azure-common azure-nspkg msrest msrestazure cryptography
        ];
        pythonNamespaces = [ "azure" ];
        pythonImportsCheck = [ ];
      });

      azure-keyvault-administration = super.azure-keyvault-administration.overridePythonAttrs(oldAttrs: rec {
        version = "4.0.0b3";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          sha256 = "sha256-d3tJWObM3plRurzfqWmHkn5CqVL9ekQfn9AeDc/KxLQ=";
        };
      });

      azure-keyvault-keys = super.azure-keyvault-keys.overridePythonAttrs(oldAttrs: rec {
        version = "4.8.0b2";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          hash = "sha256-VUwQJAwpZIQ8fzBUjUX0ui2yaVkDK7p0fwmnz373XbY=";
        };
      });


      # part of azure.mgmt.datalake namespace
      azure-mgmt-datalake-analytics = super.azure-mgmt-datalake-analytics.overrideAttrs(oldAttrs: rec {
        version = "0.2.1";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "192icfx82gcl3igr18w062744376r2ivh63c8nd7v17mjk860yac";
          extension = "zip";
        };

        preBuild = ''
          rm azure_bdist_wheel.py
          substituteInPlace setup.cfg \
            --replace "azure-namespace-package = azure-mgmt-datalake-nspkg" ""
        '';
      });

      azure-mgmt-datalake-store = super.azure-mgmt-datalake-store.overrideAttrs(oldAttrs: rec {
        version = "0.5.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-k3bTVJVmHRn4rMVgT2ewvFlJOxg1u8SA+aGVL5ABekw=";
          extension = "zip";
        };

        preBuild = ''
          rm azure_bdist_wheel.py
          substituteInPlace setup.cfg \
            --replace "azure-namespace-package = azure-mgmt-datalake-nspkg" ""
        '';
      });

      adal = super.adal.overridePythonAttrs(oldAttrs: rec {
        version = "1.2.7";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-109FuBMXRU2W6YL9HFDm+1yZrCIjcorqh2RDOjn1ZvE=";
        };

        # sdist doesn't provide tests
        doCheck = false;
      });

      msal = super.msal.overridePythonAttrs(oldAttrs: rec {
        version = "1.20.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-eDRM1MkdYTSlk7Xj5FVB5mbje3R/+KYxbDZo3R5qtrI=";
        };
      });

      semver = super.semver.overridePythonAttrs(oldAttrs: rec {
        version = "2.13.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-+g/ici7hw/V+rEeIIMOlri9iSvgmTL35AAyYD/f3Xj8=";
        };
      });

      jsondiff = super.jsondiff.overridePythonAttrs(oldAttrs: rec {
        version = "2.0.0";

        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-J5WETvB17IorjThcTVn16kiwjnGA/OPLJ4e+DbALH7Q=";
        };
      });

      knack = super.knack.overridePythonAttrs(oldAttrs: rec {
        version = "0.10.1";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-xXKBKCl+bSaXkQhc+Wwv/fzvWM+DxjSly5LrA7KSmDg=";
        };
      });

      argcomplete = super.argcomplete.overridePythonAttrs(oldAttrs: rec {
        version = "2.0.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-Y3KteMidZiA1EBQYriU2aERbORdVz+lOpS8bnSJCWyA=";
        };
      });

      sshtunnel = super.sshtunnel.overridePythonAttrs(oldAttrs: rec {
        name = "sshtunnel-${version}";
        version = "0.1.5";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0jcjppp6mdfsqrbfc3ddfxg1ybgvkjv7ri7azwv3j778m36zs4y8";
        };
      });

      websocket-client = super.websocket-client.overridePythonAttrs(oldAttrs: rec {
        version = "1.3.1";

        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-YninUGU5VBgoP4h958O+r7OqaNraXKy+SyFOjSbaSZs=";
        };
      });

    };
  };
in
  py
