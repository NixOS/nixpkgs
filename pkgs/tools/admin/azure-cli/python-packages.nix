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
        version = "1.0.4"; # might be wrong, but doesn't really matter
        inherit src;

        sourceRoot = "${src.name}/src/azure-cli-telemetry";

        propagatedBuildInputs = with super; [
          applicationinsights
          portalocker
        ];

        # upstream doesn't update this requirement probably because they use pip
        postPatch = ''
          substituteInPlace setup.py \
            --replace "portalocker~=1.6" "portalocker"
        '';

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

      azure-batch = overrideAzureMgmtPackage super.azure-batch "12.0.0" "zip"
        "sha256-GpseF4mEp79JWvZ7zOUfDbHkqKlXr7KeM1VKFKlnTes=";

      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "3.0.0" "zip"
        "9262f54ed387eb083d8dae66d32a8df35647319b902bd498cdc376f50a12d154";

      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "16.1.0" "zip"
        "sha256-9J0VQ3uAsi4kuEe9UG4xpcEV1Sc+nkjECgVfzG7j5jk=";

      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip"
        "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";

      azure-mgmt-billing = overrideAzureMgmtPackage super.azure-mgmt-billing "6.0.0" "zip"
        "d4f5c5a4188a456fe1eb32b6c45f55ca2069c74be41eb76921840b39f2f5c07f";

      azure-mgmt-botservice = overrideAzureMgmtPackage super.azure-mgmt-botservice "0.3.0" "zip"
        "f8318878a66a0685a01bf27b7d1409c44eb90eb72b0a616c1a2455c72330f2f1";

      azure-mgmt-extendedlocation = overrideAzureMgmtPackage super.azure-mgmt-extendedlocation "1.0.0b2" "zip"
        "sha256-mjfH35T81JQ97jVgElWmZ8P5MwXVxZQv/QJKNLS3T8A=";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b2" "zip"
        "sha256-e+I5MdbbX7WhxHCj1Ery3z2WUrJtpWGD1bhLbqReb58=";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.0.0" "zip"
        "bdc479b3bbcac423943d63e746a81dd5fc80b46a4dbb4393e760016e3fa4f74a";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "2.0.0" "zip"
        "sha256-p9MTfVxGD1CsLUQGHWCnC08nedTKhEt3QZtXJeZeCb4=";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "5.0.0" "zip"
        "sha256-BciA3sFyja5xo9yS3WVglC73y8gTfw8UejdEzbD4HYE=";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "21.1.0b1" "zip"
        "sha256-oiC5k+Mg9KJn940jMxG4AB9Pom+t/DWRA5KRv8HO0HI=";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "2.1.0b2" "zip"
        "sha256-/w+kI/tSNo0vW5ZFcMjRGPPrmNwZbFLKbKVkblZQ6FY=";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "13.1.0" "zip"
        "sha256-FXS834v5uDGiEGcQMIv9iaHxhfcW9uY3VmX7l91Tfj4=";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "27.0.0" "zip"
        "sha256-n+MQJ0ZeQ/hyS2G8CrNCtoxbvcfrIXmn4LXB/V6JXT0=";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerinstance = overrideAzureMgmtPackage super.azure-mgmt-containerinstance "9.1.0" "zip"
        "sha256-IhZLDFkTize8SLptR2v2NRUrxCjctCC1IaFLjCXHl60=";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "19.1.0" "zip"
        "sha256-t06Cesxvjk31aDxkX2Yj0VzFubWbiAc26LzNTIgVEqs=";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "7.0.0b2" "zip"
        "sha256-hVvYW9gkfTVMwis3IdD0JXYDxdKcyyzIFx3hNk7VMLI=";

      azure-mgmt-databoxedge = overrideAzureMgmtPackage super.azure-mgmt-databoxedge "1.0.0" "zip"
        "04090062bc1e8f00c2f45315a3bceb0fb3b3479ec1474d71b88342e13499b087";

      azure-mgmt-deploymentmanager = overrideAzureMgmtPackage super.azure-mgmt-deploymentmanager "0.2.0" "zip"
        "0c6pyr36n9snx879vas5r6l25db6nlp2z96xn759mz4kg4i45qs6";

      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "9.0.0" "zip"
        "aecbb69ecb010126c03668ca7c9a2be8e965568f5b560f0e7b5bc152b157b510";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "1.0.0" "zip"
        "634e398de9a23e712aa27a4a59f9ea5d5091d1dfcfed5ac977230918872c4430";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "2.2.0" "zip"
        "sha256-nsAeVhs5N8bpwYenmRwJmqF/IAqz/ulSoYIeOU5l0eM=";

      azure-mgmt-iothubprovisioningservices = overrideAzureMgmtPackage super.azure-mgmt-iothubprovisioningservices "1.1.0" "zip"
        "sha256-04OoJuff93L62G6IozpmHpEaUbHHHD6nKlkMHVoJvJ4=";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "10.0.0b1" "zip"
        "sha256-1CiZuTXYhIb74eGQZUJHHzovYNnnVd3Ydu1UCy2Bu00=";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip"
        "1397ksrd61jv7400mgn8sqngp6ahir55fyq9n5k69wk88169qm2r";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "7.0.0" "zip"
        "sha256-ziaddG+6MoPG18OYZyQ9HRx8nfGsz2UbWPC1pWacKto=";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "8.0.0" "zip"
        "407c2dacb33513ffbe9ca4be5addb5e9d4bae0cb7efa613c3f7d531ef7bf8de8";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "13.0.0b4" "zip"
        "sha256-Jm1t7v5vyFjNNM/evVaEI9sXJKNwJk6XAXuJSRSnKHk=";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "20.0.0" "zip"
        "sha256-mnjPyCAJ+rlNgZ4umSYjfVVVg83EobZYY/zupyDjdoY=";

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
        version = "6.0.1";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-PPkQmUoBkJ8Su7h9G2/t8dVy/PT3uCYZjlf70fnY2vU=";
        };
      });

      azure-mgmt-privatedns = overrideAzureMgmtPackage super.azure-mgmt-privatedns "1.0.0" "zip"
        "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "6.1.0" "zip"
        "c26635089276515b0488fcf014aab50a0446f54800c6e0e5583cc493ac8d738f";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "1.1.0" "zip"
        "sha256-Tq8h3fvajxIG2QjtCyHCQDE2deBDioxLLaQQek/O24U=";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "13.1.0" "zip"
        "ece913e5fc7f157e945809e557443f79ff7691cabca4bbc5ecb266352f843179";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "2.0.0" "zip"
        "sha256-5vXdXiRubnzPk4uTFeNHR6rwiHSGbeUREX9eW1pqC3E=";

      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "8.0.0" "zip"
        "a96d50c88507233a293e757202deead980c67808f432b8e897c4df1ca088da7e";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "2.0.0b1" "zip"
        "sha256-8Ksa08w8EeZEKXIk2AQ4zHCmfvTDwzV/k9I67CVusIQ=";

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "1.0.0b2" "zip"
        "sha256-FTxY8qoihHG4OZuKT3sRRlKfORbIoqDqug9Ko+6S9dw=";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "4.0.0b1" "zip"
        "sha256-dYk3stvQHN/VEZS8OBCp0IbG8g6iIHpMrLxCWWg7Id8=";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b2" "zip"
        "sha256-zqsLufjUmOl1Zxu8QhYzsEKYgoS+m8GTpRydl7jvXMk=";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b2" "zip"
        "sha256-/BAxKDttp/tS/X45y8X4KBm5qxtNuVXhrc5qB3A+wRE=";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "10.0.0" "zip"
        "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "10.0.0" "zip"
        "0856574ef4b73bbbc62834051061e2081400aba7e3715e10ef5181d639e86a0b";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "9.3.0" "zip"
        "54156422e618b686d52232a7989594b240bd18afd0fa381e12e4772ed4ab5ea8";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
        "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "8.2.0" "zip"
        "f2bcdbcf0b9fdc2df0df9eccb77cb489091d3c670ed53cba77e5ffd734e9539b";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "3.0.0" "zip"
        "91ddb7333bf2b9541a53864cc8d2501e3694a03a9c0e41cbfae3348558675ce6";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "9.0.0" "zip"
        "fc408b37315fe84781b519124f8cb1b8ac10b2f4241e439d0d3e25fd6ca18d7b";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "1.0.0" "zip"
        "c287a2c7def4de19f92c0c31ba02867fac6f5b8df71b5dbdab19288bb455fc5b";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.61.0" "zip"
        "0xfvx2dvfj3fbz4ngn860ipi4v6gxqajyjc8x92r8knhmniyxk7m";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "20.0.0" "zip"
        "sha256-buR2tWIv9vWVTt7m6w2N1CezIXAihVrfHshjPKBM3uI=";

      azure-mgmt-servicebus = overrideAzureMgmtPackage super.azure-mgmt-servicebus "7.1.0" "zip"
        "d8ae7905fb7d3e24822daa20aa7bc5014f41aa18b48ea2d0161e997fc11a3d36";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "de35e117912832c1a9e93109a8d24cab94f55703a9087b2eb1c5b0655b3b1913";

      azure-mgmt-servicelinker = overrideAzureMgmtPackage super.azure-mgmt-servicelinker "1.0.0" "zip"
        "sha256-lAjgwEa2TJDEUU8pwfwkU8EyA1bhLkcAv++I6WHb7Xs=";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "9.0.0" "zip"
        "41ebdc69c0d1f81d25dd30438c14fff4331f66639f55805b918b9649eaffe78a";

      azure-multiapi-storage = overrideAzureMgmtPackage super.azure-multiapi-storage "0.9.0" "tar.gz"
        "sha256-7uq8uRZ3MXI1Gy+DmMkRVNV7uZPw6j8r9KfhS8d+tCY=";

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
        version = "0.12.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-IfQWsITuThzh+TRgv99JTtcDFY3gMq5PjALkN4mJEZo=";
          extension = "zip";
        };
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
        version = "4.5.1";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          sha256 = "sha256-2ojnH+ySoU+1jOyIaKv366BAGI3Nzjac4QUK3RllhvY=";
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
        version = "1.18.0b1";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-kiYDjzX756uulLFr4gCuLnXgmAi+s2WDCGmvkQFC8Ow=";
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
        version = "0.9.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "7fcab17585c0236885eaef311c01a1e626d84c982aabcac81703afda3f89c81f";
        };
      });

      argcomplete = super.argcomplete.overridePythonAttrs(oldAttrs: rec {
        version = "1.8.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-SreailmO/AgRBGv3dnj4VkMnbokAzWT5xPEPEQ4QEb0=";
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
          sha256 = "sha256-YninUGU5VBgoP4h958O+r7OqaNraXKy+SyFOjSbaSZs=";
        };
      });

    };
  };
in
  py
