{ stdenv, python, lib, src, version }:

let
  buildAzureCliPackage = with py.pkgs; attrs: buildPythonPackage (attrs // {
    # Remove overly restrictive version contraints and obsolete namespace setup
    prePatch = (attrs.prePatch or "") + ''
      rm -f azure_bdist_wheel.py tox.ini
      substituteInPlace setup.py \
        --replace "wheel==0.30.0" "wheel" \
        --replace "cryptography>=2.3.1,<3.0.0" "cryptography"
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

        postPatch = ''
          substituteInPlace setup.py \
            --replace "azure-mgmt-core==1.2.1" "azure-mgmt-core~=1.2"
        '';

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

      azure-mgmt-billing = overrideAzureMgmtPackage super.azure-mgmt-billing "1.0.0" "zip"
        "8b55064546c8e94839d9f8c98e9ea4b021004b3804e192bf39fa65b603536ad0";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "0.5.0" "zip"
        "1wxh7mgrknnhqyafdd7sbwx8plx0zga2af21vs6yhxy48lw9w8pd";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "3.1.0rc1" "zip"
        "0jg242pjbxvcqskgrmw0q17mhafkip1d8p40hls0w0wn77cnic65";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "0.4.0" "zip"
        "0v0ycyjnnx09jqf958hj2q6zfpsn80bxxm98jf59y8rj09v99rz1";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "0.6.0" "zip"
        "13s2k4jl8570bj6jkqzm0w29z29rl7h5i7czd3kr6vqar5wj9xjd";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "10.3.0" "zip"
        "1bb95rlwfikfl3pgyga0v5lfgr1xyaybm1nq2498rncfcvdpkjhz";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "0.6.0" "zip"
        "0pvc8f3g12q7als0pgy26kqi2i9grykwrjyiv2vijci9wxn22vpy";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "6.3.0" "zip"
        "059lhbxqx1r1717s8xz5ahpxwphq5fgy0h7k6b63cahm818rs0hx";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "14.0.0" "zip"
        "0bvqv56plcgmnfyj0apphlbsn2vfm1a22idvy8y5npbfjz4zwja9";

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

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "0.14.0" "zip"
        "0f8m7j8sdm1rfrwizz3qfk4lyb2x02af3v66as5yqjriipk1bnbg";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "2.1.0" "zip"
        "1l55py4fzzwhxlmnwa41gpmqk9v2ncc79w7zq11sm9a5ynrv2c1p";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "0.7.0" "zip"
        "18n2lqvrhq40gdqhlzzg8mc03571i02c7qq7jv771lc58rqpzysh";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "13.0.0" "zip"
        "02ac54fs4wqdwy986j9qyx6fbl5zmpkh1sykr9r6mqk1xx9l4jq8";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "2.1.0" "zip"
        "1py0hch0wghzfxazdrrs7p0kln2zn9jh3fmkzwd2z8qggj38q6gm";

      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "0.2.0" "zip"
        "0rvik03njz940x2hvqg6iiq8k0d88gyygsr86w8s0sa12sdbq8l6";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "0.48.0" "zip"
        "1v41k9rsflbm9g06mhi6jsygv9542da53qwjpjkp532jawxrw3ys";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "0.1.0" "zip"
        "1g65lbia1i1jw6qkyjz2ldyl3p90rbr78l8kfryg70sj7z3gnnjn";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "7.0.0rc1" "zip"
        "086wk31wsl8dx14qpd0g1bly8i9a8fix007djlj9cybva2f2bk6k";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "0.6.0" "zip"
        "16ycni3cjl9c0mv419gy5rgbrlg8zp0vnr6aj8z8p2ypdw6sgac3";

      azure-mgmt-search = overrideAzureMgmtPackage super.azure-mgmt-search "2.0.0" "zip"
        "14v8ja8har2xrb00v98610pqvakcdvnzw8hkd6wbr1np3f3dxi8f";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "0.4.1" "zip"
        "08gf401d40bd1kn9wmpxcjxqdh84cd9hxm8rdjd0918483sqs71r";

      azure-mgmt-signalr = overrideAzureMgmtPackage super.azure-mgmt-signalr "0.4.0" "zip"
        "09n12ligh301z4xwixl50n8f1rgd2k6lpsxqzr6n6jvgkpdds0v5";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "0.21.0" "zip"
        "0023q32z4vn94l5aqf7h6ld4ai12a703y7glnl02lls25qfs9xvv";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "0.5.0" "zip"
        "1b9am8raa17hxnz7d5pk2ix0309wsnhnchq1mi22icd728sl5adm";

      azure-mgmt-synapse = overrideAzureMgmtPackage super.azure-mgmt-synapse "0.5.0" "zip"
        "0dr8xml9zlsnag761zx7ifvdkhsv4syzxpmdn4gbf9c5qcq65dsf";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "0.1.0" "zip"
        "1pq5rn32yvrf5kqjafnj0kc92gpfg435w2l0k7cm8gvlja4r4m77";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "4.1.0" "zip"
        "186g70slb259ybrr69zr2ibbmqgplnpncwxzg0nxp6rd7pml7d85";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "8.0.0" "zip"
        "2c974c6114d8d27152642c82a975812790a5e86ccf609bf370a476d9ea0d2e7d";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "5.2.0" "zip"
        "10b8y1b5qlyr666x7yimnwis9386ciphrxdnmmyzk90qg6h0niry";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "3.0.0rc15" "zip"
        "1fnmdl3m7kdn6c2ws5vrm7nwadcbq9mgc6g5bg4s1a4xjb23q6vb";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "0.11.0" "zip"
        "05jhn66d4sl1qi6w34rqd8wl500jndismiwhdmzzmprdvn1zxqf6";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "2.0.1" "zip"
        "1wsfkprdrn22mwm24y2zlcms8ppp7jwq3s86r3ymbl29pbaxca8r";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "0.1.1" "zip"
        "16raxr5naszrxmgbfhsvh7rqcph5cx6x3f480790m79ykvmjj0pi";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.61.0" "zip"
        "0xfvx2dvfj3fbz4ngn860ipi4v6gxqajyjc8x92r8knhmniyxk7m";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "16.0.0" "zip"
        "2f9d714d9722b1ef4bac6563676612e6e795c4e90f6f3cd323616fdadb0a99e5";

      azure-mgmt-servicebus = overrideAzureMgmtPackage super.azure-mgmt-servicebus "0.6.0" "zip"
        "1c88pj8diijciizw4c6g1g6liz54cp3xmlm4xnmz97hizfw202gj";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "0.5.0" "zip"
        "0x6wxb9zrvcayg3yw0nm99p10vvgc0x3zwk9amzs5m682r2z4wap";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "2.0.0" "zip"
        "fd47029f2423e45ec4d311f651dc972043b98e960f186f5c6508c6fdf6eb2fe8";

      azure-multiapi-storage = overrideAzureMgmtPackage super.azure-multiapi-storage "0.5.2" "tar.gz"
        "09y075mc7kig4dlb0xdvdvl9xbr931bi7kv60xaqnf31pf4pb7gf";

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
        version = "0.3.0";
        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0p43zmw96fh3wp75phf3fcqdfb36adqvxfc945yfda6fi555nw1a";
          extension = "zip";
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

      sshtunnel = super.sshtunnel.overridePythonAttrs(oldAttrs: rec {
        name = "sshtunnel-${version}";
        version = "0.1.5";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0jcjppp6mdfsqrbfc3ddfxg1ybgvkjv7ri7azwv3j778m36zs4y8";
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
