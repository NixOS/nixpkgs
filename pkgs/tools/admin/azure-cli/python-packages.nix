{ stdenv, python3, lib, src, version }:

let
  buildAzureCliPackage = with py.pkgs; attrs: buildPythonPackage attrs;

  overrideAzureMgmtPackage = package: version: extension: sha256:
    # check to make sure overriding is even necessary
    if version == package.version then
      package
    else package.overrideAttrs(oldAttrs: rec {
      inherit version;

      src = py.pkgs.fetchPypi {
        inherit (oldAttrs) pname;
        inherit version sha256 extension;
      };

      preBuild = ''
        rm -f azure_bdist_wheel.py
        substituteInPlace setup.cfg \
          --replace "azure-namespace-package = azure-mgmt-nspkg" ""
      '';

      # force PEP420
      pythonNamespaces = [ "azure.mgmt" ];
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
          pyyaml
          requests
          six
          tabulate
        ];

        postPatch = ''
          substituteInPlace setup.py \
            --replace "requests[socks]~=2.25.1" "requests[socks]~=2.25" \
            --replace "cryptography>=3.2,<3.4" "cryptography"
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

      azure-batch = overrideAzureMgmtPackage super.azure-batch "11.0.0" "zip"
        "sha256-zl/bDsli7d/oXNgiBekXfLC720RSZXRuOLO7vx8W3HM=";

      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "0.2.0" "zip"
        "0whx3s8ri9939r3pdvjf8iqcslas1xy6cnccidmp10r5ng0023vr";

      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "16.0.0" "zip"
        "1b3cecd6f16813879c6ac1a1bb01f9a6f2752cd1f9157eb04d5e41e4a89f3c34";

      azure-mgmt-batchai = overrideAzureMgmtPackage super.azure-mgmt-batchai "7.0.0b1" "zip"
        "sha256-mT6vvjWbq0RWQidugR229E8JeVEiobPD3XA/nDM3I6Y=";

      azure-mgmt-billing = overrideAzureMgmtPackage super.azure-mgmt-billing "6.0.0" "zip"
        "d4f5c5a4188a456fe1eb32b6c45f55ca2069c74be41eb76921840b39f2f5c07f";

      azure-mgmt-botservice = overrideAzureMgmtPackage super.azure-mgmt-botservice "0.3.0" "zip"
        "f8318878a66a0685a01bf27b7d1409c44eb90eb72b0a616c1a2455c72330f2f1";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.0.0" "zip"
        "75103fb4541aeae30bb687dee1fedd9ca65530e6b97b2d9ea87f74816905202a";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.0.0" "zip"
        "bdc479b3bbcac423943d63e746a81dd5fc80b46a4dbb4393e760016e3fa4f74a";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "2.0.0" "zip"
        "sha256-p9MTfVxGD1CsLUQGHWCnC08nedTKhEt3QZtXJeZeCb4=";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "4.0.0" "zip"
        "a848ac1d99c935e61dfb91ca3e1577904a3eff5820fce179eb6937df8e1019ec";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "20.0.0" "zip"
        "622dca4484be64f9f5ce335d327dffabf3e71e14e8a3f4a1051dc85a5c3ebbca";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "2.0.0" "zip"
        "b58bbe82a7429ba589292024896b58d96fe9fa732c578569cac349928dc2ca5f";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "13.0.0" "zip"
        "dc6116e8394d45312c7ad5a9098ce0dd2370bd92d43afd33d8b3bfab724fa498";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "23.1.0" "zip"
        "sha256-Sduw9RAG1VfL0LIpmcuezz6rwr5G2W78xtZRxrM3VLM=";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerinstance = overrideAzureMgmtPackage super.azure-mgmt-containerinstance "9.1.0" "zip"
        "sha256-N+zUTEnOyn18lDHlkUj+vRXX/sJhZR7XLd1YdV50ULA=";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "16.1.0" "zip"
        "sha256-NlTIrOK4ho0OqcTHjHT1HobiMzDH2KY20TIlN0fm8/Q=";

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

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "2.1.0" "zip"
        "2724f48cadb1be7ee96fc26c7bfa178f82cea5d325e785e91d9f26965fa8e46f";

      azure-mgmt-iothubprovisioningservices = overrideAzureMgmtPackage super.azure-mgmt-iothubprovisioningservices "1.0.0" "zip"
        "e5871b03488b5ae6dfc441cdbda40cb39c000635ee57c513053792b3c15826a9";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "9.0.0" "zip"
        "64df73df449a6f3717f3d0963e5869224ed3e6216c79de571493bea7c1b52cb6";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip"
        "1397ksrd61jv7400mgn8sqngp6ahir55fyq9n5k69wk88169qm2r";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "5.1.0" "zip"
        "sha256-MGCICI7hDobEzyTMgqnKYZ21zfwNo/ogfQDsf3fwbo4=";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "8.0.0" "zip"
        "407c2dacb33513ffbe9ca4be5addb5e9d4bae0cb7efa613c3f7d531ef7bf8de8";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "12.0.0" "zip"
        "da128a7e0291be7fa2063848df92a9180cf5c16d42adc09d2bc2efd711536bfb";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "19.3.0" "zip"
        "0b6a1ccdffd76e057ab16a6c319740a0ca68d59fedf7e9c02f2437396e72aa11";

      azure-mgmt-maps = overrideAzureMgmtPackage super.azure-mgmt-maps "2.0.0" "zip"
        "384e17f76a68b700a4f988478945c3a9721711c0400725afdfcb63cf84e85f0e";

      azure-mgmt-managedservices = overrideAzureMgmtPackage super.azure-mgmt-managedservices "1.0.0" "zip"
        "sha256-/tg5n8Z3Oq2jfB0ElqRvWUENd8lJTQyllnxTHDN2rRk=";

      azure-mgmt-managementgroups = overrideAzureMgmtPackage super.azure-mgmt-managementgroups "0.1.0" "zip"
        "sha256-/2LZgu3aY0o2Fgyx0Vo2epVypay0GeXnrTcejIO9R8c=";

      azure-mgmt-marketplaceordering = overrideAzureMgmtPackage super.azure-mgmt-marketplaceordering "1.1.0" "zip"
        "68b381f52a4df4435dacad5a97e1c59ac4c981f667dcca8f9d04453417d60ad8";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "7.0.0" "zip"
        "sha256-tF6CpZTtkc1ap6XNXQHwOLesPPEiM+e6K+qqNHeQDo4=";

      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "0.2.0" "zip"
        "0rvik03njz940x2hvqg6iiq8k0d88gyygsr86w8s0sa12sdbq8l6";

      azure-mgmt-privatedns = overrideAzureMgmtPackage super.azure-mgmt-privatedns "1.0.0" "zip"
        "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "4.0.0" "zip"
        "sha256-5XQ3qTPn3qmwYY/nkODa3GP5hXc1NhrItfXoBiucKg0=";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "1.0.0" "zip"
        "94cd41f1ebd82e40620fd3e6d88f666b5c19ac7cf8b4e8edadb9721bd7c80980";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "13.1.0" "zip"
        "ece913e5fc7f157e945809e557443f79ff7691cabca4bbc5ecb266352f843179";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "0.6.0" "zip"
        "16ycni3cjl9c0mv419gy5rgbrlg8zp0vnr6aj8z8p2ypdw6sgac3";

      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "8.0.0" "zip"
        "a96d50c88507233a293e757202deead980c67808f432b8e897c4df1ca088da7e";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "2.0.0b1" "zip"
        "sha256-8Ksa08w8EeZEKXIk2AQ4zHCmfvTDwzV/k9I67CVusIQ=";

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "1.0.0b2" "zip"
        "sha256-FTxY8qoihHG4OZuKT3sRRlKfORbIoqDqug9Ko+6S9dw=";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "3.0.1" "zip"
        "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b1" "zip"
        "sha256-SrFTvU+67U3CpMLPZMawXuRdSIbTsfav2jFZIsZWPmw=";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b2" "zip"
        "sha256-/BAxKDttp/tS/X45y8X4KBm5qxtNuVXhrc5qB3A+wRE=";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "10.0.0" "zip"
        "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "9.1.0" "zip"
        "0ba9f10e1e8d03247a316e777d6f27fabf268d596dda2af56ac079fcdf5e7afe";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "9.3.0" "zip"
        "54156422e618b686d52232a7989594b240bd18afd0fa381e12e4772ed4ab5ea8";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "11.0.0" "zip"
        "28e7070001e7208cdb6c2ad253ec78851abdd73be482230d2c0874eed5bc0907";

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

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "19.0.0" "zip"
        "f05963e5a8696d0fd4dcadda4feecb9b382a380d2e461b3647704ac787d79876";

      azure-mgmt-servicebus = overrideAzureMgmtPackage super.azure-mgmt-servicebus "6.0.0" "zip"
        "f6c64ed97d22d0c03c4ca5fc7594bd0f3d4147659c10110160009b93f541298e";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "1.0.0" "zip"
        "de35e117912832c1a9e93109a8d24cab94f55703a9087b2eb1c5b0655b3b1913";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "9.0.0" "zip"
        "41ebdc69c0d1f81d25dd30438c14fff4331f66639f55805b918b9649eaffe78a";

      azure-multiapi-storage = overrideAzureMgmtPackage super.azure-multiapi-storage "0.7.0" "tar.gz"
        "cd4f184be8c9ca8aca969f93ed50dc7fe556d28ca11520440fc182cf876abdf9";

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
        version = "0.10.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-P3gsm1kLiuQ2eMbgA9+MqMymdYMgOdJwsLdDf/AVV/0=";
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
        version = "4.5.0b4";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          sha256 = "sha256-f43ZTMFc0IVIaa69gEZFOLALREcx3RRCFoYDY2FYLrY=";
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

      semver = super.semver.overridePythonAttrs(oldAttrs: rec {
        version = "2.13.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-+g/ici7hw/V+rEeIIMOlri9iSvgmTL35AAyYD/f3Xj8=";
        };
      });

      PyGithub = super.PyGithub.overridePythonAttrs(oldAttrs: rec {
        version = "1.38";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-HtCPd17FBnvIRStyveLbuVz05S/yvVDMMsackf+tknI=";
        };

        doCheck = false;
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
        version = "0.56.0";

        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0fpxjyr74klnyis3yf6m54askl0h5dchxcwbfjsq92xng0455m8z";
        };
      });

    };
  };
in
  py
