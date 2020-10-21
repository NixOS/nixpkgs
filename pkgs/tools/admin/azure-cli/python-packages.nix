{ stdenv, python, lib, src, version }:

let
  buildAzureCliPackage = with py.pkgs; attrs: buildPythonPackage (attrs // {
    # Remove overly restrictive version contraints and obsolete namespace setup
    prePatch = (attrs.prePatch or "") + ''
      rm -f azure_bdist_wheel.py tox.ini
      substituteInPlace setup.py \
        --replace "wheel==0.30.0" "wheel"
      sed -i "/azure-namespace-package/c\ " setup.cfg
    '';

    # Prevent these __init__'s from violating PEP420, only needed for python2
    pythonNamespaces = [ "azure.cli" ];

    checkInputs = [ mock pytest ] ++ (attrs.checkInputs or []);
    checkPhase = attrs.checkPhase or ''
      cd azure
      HOME=$TMPDIR pytest
    '';
  });

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

  py = python.override {
    packageOverrides = self: super: {
      inherit buildAzureCliPackage;

      # core and the actual application are highly coupled
      azure-cli-core = buildAzureCliPackage {
        pname = "azure-cli-core";
        inherit version src;

        sourceRoot = "source/src/azure-cli-core";

        propagatedBuildInputs = with self; [
          adal
          argcomplete
          azure-common
          azure-cli-telemetry
          azure-mgmt-core
          azure-mgmt-resource
          colorama
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
        ]
        ++ lib.optionals isPy3k [ antlr4-python3-runtime ]
        ++ lib.optionals (!isPy3k) [ enum34 futures antlr4-python2-runtime ndg-httpsclient ];

        doCheck = stdenv.isLinux;
        # ignore tests that does network call
        checkPhase = ''
          rm azure/{,cli/}__init__.py
          python -c 'import azure.common; print(azure.common)'
          PYTHONPATH=$PWD:$PYTHONPATH HOME=$TMPDIR pytest \
            --ignore=azure/cli/core/tests/test_profile.py \
            --ignore=azure/cli/core/tests/test_generic_update.py \
            -k 'not metadata_url'
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

        sourceRoot = "source/src/azure-cli-telemetry";

        propagatedBuildInputs = with super; [
          applicationinsights
          portalocker
        ];

        # ignore flaky test
        checkPhase = ''
          cd azure
          HOME=$TMPDIR pytest -k 'not test_create_telemetry_note_file_from_scratch'
        '';
      };

      azure-batch = overrideAzureMgmtPackage super.azure-batch "9.0.0" "zip"
        "112d73gxjqng348mcvi36ska6pxyg8qc3qswvhf5x4a0lr86zjj7";

      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "0.2.0" "zip"
        "0whx3s8ri9939r3pdvjf8iqcslas1xy6cnccidmp10r5ng0023vr";

      azure-mgmt-batch = overrideAzureMgmtPackage super.azure-mgmt-batch "9.0.0" "zip"
        "1zn3yqwvm2f3sy8v0xvj4yb7m8kxxm1wpcaccxp91b0zzbn7wh83";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "0.5.0" "zip"
        "1wxh7mgrknnhqyafdd7sbwx8plx0zga2af21vs6yhxy48lw9w8pd";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "3.0.0rc1" "zip"
        "0afg5vmyiwqna9rnal9ir2vyg2mykllsf313gd3kn99jl21bgns1";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "0.4.0" "zip"
        "0v0ycyjnnx09jqf958hj2q6zfpsn80bxxm98jf59y8rj09v99rz1";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "0.6.0" "zip"
        "13s2k4jl8570bj6jkqzm0w29z29rl7h5i7czd3kr6vqar5wj9xjd";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "10.2.0" "zip"
        "ddfe4c0c55f0e3fd1f66dd82c1d4a3d872ce124639b9a77fcd172daf464438a5";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "0.6.0" "zip"
        "0pvc8f3g12q7als0pgy26kqi2i9grykwrjyiv2vijci9wxn22vpy";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "6.2.0" "zip"
        "1khk9jdfx7706xsqpwrnfsplv6p6wracvpyk9ki8zhc7p83kal4k";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "13.0.0" "zip"
        "17ik8lfd74ki57rml2piswcanzbladsqy0s2m9jmvwpdrfpincvz";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerinstance = overrideAzureMgmtPackage super.azure-mgmt-containerinstance "1.4.0" "zip"
        "1qw6228bia5pimcijr755npli2l33jyfka1s2bzgl1w4h3prsji7";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "9.4.0" "zip"
        "1jfs2v0bblpn8lg98zgll6f7k7247r6vwrr0p1898xvhdh8881nr";

      azure-mgmt-core = overrideAzureMgmtPackage super.azure-mgmt-core "1.2.0" "zip"
        "8fe3b59446438f27e34f7b24ea692a982034d9e734617ca1320eedeee1939998";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "1.0.0" "zip"
        "08xp04mkl5ajwyr0l62c8bfb4n8p9s9fp6szynb2bdp6m2p3g2z0";

      azure-mgmt-deploymentmanager = overrideAzureMgmtPackage super.azure-mgmt-deploymentmanager "0.2.0" "zip"
        "0c6pyr36n9snx879vas5r6l25db6nlp2z96xn759mz4kg4i45qs6";

      azure-mgmt-eventgrid = overrideAzureMgmtPackage super.azure-mgmt-eventgrid "3.0.0rc7" "zip"
        "1m5905mn362pn03sf89zsnylkrbgs4p1lkafrw3nxa2gnwcfpyb8";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "0.4.0" "zip"
        "0cqpjnkpid6a34ifd4vk4fn1h57pa1bg3r756wv082xl2szr34jc";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "0.12.0" "zip"
        "187z0w5by7d9a2zsz3kidmzjw591akpc6dwhps4jyb4skcmyw86s";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "3.0.0" "zip"
        "0iq04hvivq3fvg2lhax95gx0x35avk5hps42227z3qna5i2cznpn";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "4.0.0" "zip"
        "1397ksrd61jv7400mgn8sqngp6ahir55fyq9n5k69wk88169qm2r";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "0.12.0" "zip"
        "7d773119bc02e3d6f9d7cffb7effc17e85676d5c5b1f656d05abc4489e472c76";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "2.1.0" "zip"
        "1l55py4fzzwhxlmnwa41gpmqk9v2ncc79w7zq11sm9a5ynrv2c1p";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "0.7.0" "zip"
        "18n2lqvrhq40gdqhlzzg8mc03571i02c7qq7jv771lc58rqpzysh";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "12.0.0" "zip"
        "150074lnld426lv37v4gy41cqqvj57zw4mrz5svv7iynljb2jl3l";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "2.1.0" "zip"
        "1py0hch0wghzfxazdrrs7p0kln2zn9jh3fmkzwd2z8qggj38q6gm";

      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "0.2.0" "zip"
        "0rvik03njz940x2hvqg6iiq8k0d88gyygsr86w8s0sa12sdbq8l6";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "0.47.0" "zip"
        "1s6c477q2kpyiqkisw6l70ydyjkv3ay6zjjj4jl4ipv05a7356kq";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "0.1.0" "zip"
        "1g65lbia1i1jw6qkyjz2ldyl3p90rbr78l8kfryg70sj7z3gnnjn";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "7.0.0rc1" "zip"
        "086wk31wsl8dx14qpd0g1bly8i9a8fix007djlj9cybva2f2bk6k";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "0.6.0" "zip"
        "16ycni3cjl9c0mv419gy5rgbrlg8zp0vnr6aj8z8p2ypdw6sgac3";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "0.4.1" "zip"
        "08gf401d40bd1kn9wmpxcjxqdh84cd9hxm8rdjd0918483sqs71r";

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "0.4.0" "zip"
        "09n12ligh301z4xwixl50n8f1rgd2k6lpsxqzr6n6jvgkpdds0v5";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "0.21.0" "zip"
        "0023q32z4vn94l5aqf7h6ld4ai12a703y7glnl02lls25qfs9xvv";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "0.5.0" "zip"
        "1b9am8raa17hxnz7d5pk2ix0309wsnhnchq1mi22icd728sl5adm";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "0.3.0" "zip"
        "0sa12s5af9xl1wnblilswxc6ydr2anm9an000iz3ks54pydby2vy";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "0.1.0" "zip"
        "1pq5rn32yvrf5kqjafnj0kc92gpfg435w2l0k7cm8gvlja4r4m77";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "4.1.0" "zip"
        "186g70slb259ybrr69zr2ibbmqgplnpncwxzg0nxp6rd7pml7d85";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "7.0.0b3" "zip"
        "1w8kp4r8v54cr4sskkgv5mbqx2pisrly2066ma5msg6amy97jnr6";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "5.0.0" "zip"
        "0y1bq6lirwx4n8zydi49jx72xfc7dppzhy82x22sx98id8lxgcwm";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "3.0.0rc14" "zip"
        "0w9hnxvk5pcsa21g3xrr089rfwgldghrbj8akzvh0gchqlzfjg6j";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "0.11.0" "zip"
        "05jhn66d4sl1qi6w34rqd8wl500jndismiwhdmzzmprdvn1zxqf6";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "2.0.1" "zip"
        "1wsfkprdrn22mwm24y2zlcms8ppp7jwq3s86r3ymbl29pbaxca8r";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "0.1.1" "zip"
        "16raxr5naszrxmgbfhsvh7rqcph5cx6x3f480790m79ykvmjj0pi";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.61.0" "zip"
        "0xfvx2dvfj3fbz4ngn860ipi4v6gxqajyjc8x92r8knhmniyxk7m";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "11.2.0" "zip"
        "0a05djzgwnd9lwj5mazmjfv91k72v9scf612kf6vkjjq7jzkr3pw";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "0.5.0" "zip"
        "0x6wxb9zrvcayg3yw0nm99p10vvgc0x3zwk9amzs5m682r2z4wap";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "1.7.0" "zip"
        "004q3d2kj1i1cx3sad1544n3pkindfm255sw19gdlhbw61wn5l5a";

      azure-multiapi-storage = overrideAzureMgmtPackage super.azure-multiapi-storage "0.4.1" "zip"
        "0h7bzaqwyl3j9xqzjbnwxp59kmg6shxk76pml9kvvqbwsq9w6fx3";

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

      azure-synapse-accesscontrol = super.azure-synapse-accesscontrol.overrideAttrs(oldAttrs: rec {
        version = "0.2.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1rsdqrhrgy09kbw6c7krb4hlaxs1ldb6lilwrbxgp3zqybxxnh5b";
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
        version = "4.0.0b1";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          extension = "zip";
          sha256 = "1kmf2x3jdmfm9c7ldvajzckkm79gxxvl1l2968lizjwiyjbbsih5";
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

      cryptography = super.cryptography.overridePythonAttrs(oldAttrs: rec {
        version = "2.9.2";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0af25w5mkd6vwns3r6ai1w5ip9xp0ms9s261zzssbpadzdr05hx0";
        };

        # prevent cycle with cryptography-vectors
        doCheck = false;
      });

      knack = super.knack.overridePythonAttrs(oldAttrs: rec {
        version = "0.7.2";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1jh81xyri7wb7vqa049imf6dfy3nc501bq3p0miaka8ffvvaxinz";
        };
      });

      msal = super.msal.overridePythonAttrs(oldAttrs: rec {
        version = "1.0.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0h33wayvakggr684spdyhiqvrwraavcbk3phmcbavb3zqxd3zgpc";
        };
      });

      msal-extensions = super.msal-extensions.overridePythonAttrs(oldAttrs: rec {
        version = "0.1.3";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1p05cbfksnhijx1il7s24js2ydzgxbpiasf607qdpb5sljlp3qar";
        };
      });

      websocket_client = super.websocket_client.overridePythonAttrs(oldAttrs: rec {
        version = "0.56.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0fpxjyr74klnyis3yf6m54askl0h5dchxcwbfjsq92xng0455m8z";
        };
      });

    };
  };
in
  py
