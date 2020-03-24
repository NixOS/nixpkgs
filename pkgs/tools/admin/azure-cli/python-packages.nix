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

      # force PEP420
      postInstall = ''
        rm -f $out/${py.sitePackages}/azure/{,mgmt/}__init__.py
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

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "0.4.0" "zip"
        "1b69rz9wm0jvc54vx3b7h633x8gags51xwxrkp6myar40jggxw6g";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "1.9.0" "zip"
        "0v91hl936wp9sl3bc31svf6kdxwa57qh6ih9rrv43dnb2000km6r";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "0.6.0" "zip"
        "13s2k4jl8570bj6jkqzm0w29z29rl7h5i7czd3kr6vqar5wj9xjd";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "8.0.1" "zip"
        "0gngm7w17r5922ji11pnpa6gp5vh5z6la025v9cda6smsnx0fxx7";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "0.4.0" "zip"
        "1dn5585nsizszjivx6lp677ka0mrg0ayqgag4yzfdz9ml8mj1xl5";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "10.0.0" "zip"
        "1s3bx6knxw5dxycp43yimvgrh0i19drzd09asglcwz2x5mr3bpyg";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "8.1.0" "zip"
        "07vpzhvi2946v5dn9cb2hkd1b9vj5c6zl32958bg2bxsjg9vvyi1";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "0.11.0" "zip"
        "05j0s2ng6ck35lw85cbjf5cm6canc71c41aagr68cmiqj1li6v1z";

      azure-mgmt-deploymentmanager = overrideAzureMgmtPackage super.azure-mgmt-deploymentmanager "0.2.0" "zip"
        "0c6pyr36n9snx879vas5r6l25db6nlp2z96xn759mz4kg4i45qs6";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "0.2.1" "zip"
        "0mwlvy4x5nr3hsz7wdpdhpzwarzzwz4225bfpd68hr0pcjgzspky";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "0.8.2" "zip"
        "0w3w1d156rnkwjdarv3qvycklxr3z2j7lry7a3jfgj3ykzny12rq";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "2.0.0" "zip"
        "1fql0j28d2r6slgabb7b438gdga513iskqh4al6c7dsmj1yzdzwa";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "2.2.0" "zip"
        "15lpyv9z8ss47rjmg1wx5akh22p9br2vckaj7jk3639vi38ac5nl";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "0.7.0" "zip"
        "0cf4pknb5y2yz4jqwg7xm626zkfx8i8hqcr3dkvq21lrx7fz96r3";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "2.1.0" "zip"
        "1l55py4fzzwhxlmnwa41gpmqk9v2ncc79w7zq11sm9a5ynrv2c1p";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "9.0.0" "zip"
        "12bsdbh37xiz42hvrp8ghszyqkiali3pk50x44f3aip12pgx6kix";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "1.1.1" "zip"
        "16wk0ksycrscsn3n14qk4vvf7i567vq6f96lwf5dwbc81wx6n32x";

      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "0.2.0" "zip"
        "0rvik03njz940x2hvqg6iiq8k0d88gyygsr86w8s0sa12sdbq8l6";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "0.44.0" "zip"
        "05dqakhfi301k2jnvccxdkigqvwnf9xz858pqg9vsri3dq69f1rw";

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

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "3.0.0" "zip"
        "05c6isg13dslds94kv28v6navxj4bp4c5lsd9df0g3ndsxvpdrxp";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "2.1.0" "zip"
        "1ikv8b2h1r91fa0srz95ymn54qpqgb5a4faxwp4hf92r5h85c8j9";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "4.0.0" "zip"
        "0aphqh4mvrc1yiyis8zvks0d19d1m3lqylr9jc8fj73iw84rwgm5";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "3.0.0rc8" "zip"
        "1j2xyfid0qg95lywwsz8520r7gd8m0a487n03jxnckr91vd890v1";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "0.7.0" "zip"
        "1pprvk5255b6brbw73g0g13zygwa7a2px5x08wy3153rqlzan5l2";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "2.0.1" "zip"
        "1wsfkprdrn22mwm24y2zlcms8ppp7jwq3s86r3ymbl29pbaxca8r";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "0.1.1" "zip"
        "16raxr5naszrxmgbfhsvh7rqcph5cx6x3f480790m79ykvmjj0pi";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.52.0" "zip"
        "0357laxgldb7lvvws81r8xb6mrq9dwwnr1bnwdnyj4bw6p21i9hn";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "7.2.0" "zip"
        "01ck1ankgr9ikvfghhdcs777yrl2j2p8cw9q8nfdrjp22lpchabl";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "0.4.0" "zip"
        "1x18grkjf2p2r1ihlwv607sna9yjvsr2jwnkjc55askrgrwx5jx2";

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
