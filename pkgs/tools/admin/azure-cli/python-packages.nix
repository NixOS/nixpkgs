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
    postInstall = (attrs.postInstall or "") + ''
      rm $out/${python.sitePackages}/azure/{,__pycache__/}__init__.* \
         $out/${python.sitePackages}/azure/cli/{,__pycache__/}__init__.*
    '';

    checkInputs = [ mock pytest ] ++ (attrs.checkInputs or []);
    checkPhase = attrs.checkPhase or ''
      cd azure
      HOME=$TMPDIR pytest
    '';
  });

  overrideAzureMgmtPackage = package: version: extension: sha256:
    package.overrideAttrs(oldAttrs: rec {
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
          azure-mgmt-resource
          colorama
          humanfriendly
          jmespath
          knack
          msrest
          msrestazure
          paramiko
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
        # ignore test that does network call
        checkPhase = ''
          rm azure/{,cli/}__init__.py
          python -c 'import azure.common; print(azure.common)'
          PYTHONPATH=$PWD:$PYTHONPATH HOME=$TMPDIR pytest \
            --ignore=azure/cli/core/tests/test_profile.py \
            --ignore=azure/cli/core/tests/test_generic_update.py
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

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "0.5.0" "zip"
        "0jhq8fi3dn2cncyv2rrgr4kldd254f30zgwf6p85rdgvg2p9k4hl";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "6.0.0" "zip"
        "08n6r6ja7p20qlhb9pp51nwwxz2mal19an98zry276i8z5x8ckp0";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "10.0.0" "zip"
        "1s3bx6knxw5dxycp43yimvgrh0i19drzd09asglcwz2x5mr3bpyg";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "8.0.0" "zip"
        "0akpm12xj453dp84dfdpi06phr4q0hknr5l7bz96zbc8iand78wg";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "0.11.0" "zip"
        "05j0s2ng6ck35lw85cbjf5cm6canc71c41aagr68cmiqj1li6v1z";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "0.2.1" "zip"
        "0mwlvy4x5nr3hsz7wdpdhpzwarzzwz4225bfpd68hr0pcjgzspky";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "0.8.2" "zip"
        "0w3w1d156rnkwjdarv3qvycklxr3z2j7lry7a3jfgj3ykzny12rq";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "1.0.0" "zip"
        "1s1x0pzynz0sd0l4k1kvkph9i1y03y9qd6afbw0nafcr3znqib4s";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "2.2.0" "zip"
        "15lpyv9z8ss47rjmg1wx5akh22p9br2vckaj7jk3639vi38ac5nl";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "0.7.0" "zip"
        "0cf4pknb5y2yz4jqwg7xm626zkfx8i8hqcr3dkvq21lrx7fz96r3";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "2.1.0" "zip"
        "1l55py4fzzwhxlmnwa41gpmqk9v2ncc79w7zq11sm9a5ynrv2c1p";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "7.0.0" "zip"
        "0ss5yc9k3dh78lb88nfh3z98yz1pcd8d7d7cfjlxmv4n3dlr1kij";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "1.1.1" "zip"
        "16wk0ksycrscsn3n14qk4vvf7i567vq6f96lwf5dwbc81wx6n32x";

      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "0.2.0" "zip"
        "0rvik03njz940x2hvqg6iiq8k0d88gyygsr86w8s0sa12sdbq8l6";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "0.42.0" "zip"
        "0vp40i9aaw5ycz7s7qqir6jq7327f7zg9j9i8g31qkfl1h1c7pdn";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "7.0.0rc1" "zip"
        "086wk31wsl8dx14qpd0g1bly8i9a8fix007djlj9cybva2f2bk6k";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "0.6.0" "zip"
        "16ycni3cjl9c0mv419gy5rgbrlg8zp0vnr6aj8z8p2ypdw6sgac3";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "0.1.0" "zip"
        "1cb466722bs0ribrirb32kc299716pl0pwivz3jyn40dd78cwhhx";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "0.15.0" "zip"
        "0qv58xraznv2ldhd34cvznhz045x3ncfgam9c12gxyj4q0k3pyc9";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "0.5.0" "zip"
        "1b9am8raa17hxnz7d5pk2ix0309wsnhnchq1mi22icd728sl5adm";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "0.1.0" "zip"
        "1pq5rn32yvrf5kqjafnj0kc92gpfg435w2l0k7cm8gvlja4r4m77";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "2.6.0" "zip"
        "1nnp2ki4iz4f4897psmwb0v5khrwh84fgxja7nl7g73g3ym20sz8";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "1.1.0" "zip"
        "16a0d3j5dilbp7pd7gbwf8jr46vzbjim1p9alcmisi12m4km7885";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "3.1.0" "zip"
        "1qvnksmvsg8cw1ac6vbdxjdqsm7s1sak27k8xy24hm7c9a8y1nqc";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "3.0.0rc7" "zip"
        "1bzfpbz186dhnxn0blgr20xxnk67gkr8ysn2b3f1r41bq9hz97xp";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "0.7.0" "zip"
        "1pprvk5255b6brbw73g0g13zygwa7a2px5x08wy3153rqlzan5l2";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "2.0.1" "zip"
        "1wsfkprdrn22mwm24y2zlcms8ppp7jwq3s86r3ymbl29pbaxca8r";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "0.1.1" "zip"
        "16raxr5naszrxmgbfhsvh7rqcph5cx6x3f480790m79ykvmjj0pi";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.52.0" "zip"
        "0357laxgldb7lvvws81r8xb6mrq9dwwnr1bnwdnyj4bw6p21i9hn";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "7.1.0" "zip"
        "03yjvw1dwkwsadsv60i625mr9zpdryy7ywvh7p8fg60djszh1p5l";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "0.2.0" "zip"
        "1bcq6fcgrsvmk6q7v8mxzn1180jm2qijdqkqbv1m117zp1wj5gxj";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "1.3.0" "zip"
        "1r7isr7hzq2dv1idwwa9xxxgk8wh0ncka45r4rdcsl1p7kd2kqam";

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
        postInstall = ''
          rm -f $out/${self.python.sitePackages}/azure/__init__.py
        '';
        pythonImportsCheck = [ ];
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

    };
  };
in
  py
