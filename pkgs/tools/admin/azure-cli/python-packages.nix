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

      azure-batch = overrideAzureMgmtPackage super.azure-batch "9.0.0" "zip"
        "112d73gxjqng348mcvi36ska6pxyg8qc3qswvhf5x4a0lr86zjj7";

      azure-mgmt-apimanagement = overrideAzureMgmtPackage super.azure-mgmt-apimanagement "0.1.0" "zip"
        "06bqqkn5mx127x1z7ycm6rl8ajxlrmrm2kcdpgkbl4baii1x6iax";

      azure-mgmt-policyinsights = overrideAzureMgmtPackage super.azure-mgmt-policyinsights "0.4.0" "zip"
        "1b69rz9wm0jvc54vx3b7h633x8gags51xwxrkp6myar40jggxw6g";

      azure-mgmt-rdbms = overrideAzureMgmtPackage super.azure-mgmt-rdbms "2.2.0" "zip"
        "1iz1pf28ajrzbq8nab1jbjbgfbv0g6ni036xayy6xylvga4l8czr";

      azure-mgmt-recoveryservices = overrideAzureMgmtPackage super.azure-mgmt-recoveryservices "0.4.0" "zip"
        "0v0ycyjnnx09jqf958hj2q6zfpsn80bxxm98jf59y8rj09v99rz1";

      azure-mgmt-recoveryservicesbackup = overrideAzureMgmtPackage super.azure-mgmt-recoveryservicesbackup "0.6.0" "zip"
        "13s2k4jl8570bj6jkqzm0w29z29rl7h5i7czd3kr6vqar5wj9xjd";

      azure-mgmt-resource = overrideAzureMgmtPackage super.azure-mgmt-resource "9.0.0" "zip"
        "00bmdbr7hdwb3ibr9sfbgbmmr6626qlz19cdi84d87rcisczf4nw";

      azure-mgmt-appconfiguration = overrideAzureMgmtPackage super.azure-mgmt-appconfiguration "0.4.0" "zip"
        "1dn5585nsizszjivx6lp677ka0mrg0ayqgag4yzfdz9ml8mj1xl5";

      azure-mgmt-cognitiveservices = overrideAzureMgmtPackage super.azure-mgmt-cognitiveservices "5.0.0" "zip"
        "1m7v3rfkvmdgghrpz15fm8pvmmhi40lcwfxdm2kxh7mx01r5l906";

      azure-mgmt-compute = overrideAzureMgmtPackage super.azure-mgmt-compute "12.0.0" "zip"
        "0vzq93g2fpnij4rykkk3391xq2knhlbz87vhim4zvj8s45sx6z8q";

      azure-mgmt-consumption = overrideAzureMgmtPackage super.azure-mgmt-consumption "2.0.0" "zip"
        "12ai4qps73ivawh0yzvgb148ksx02r30pqlvfihx497j62gsi1cs";

      azure-mgmt-containerservice = overrideAzureMgmtPackage super.azure-mgmt-containerservice "9.0.1" "zip"
        "11nqjpi9qypb0xvfy63l98q5m5jfv5iqx15mliksm96vkdkmji3y";

      azure-mgmt-cosmosdb = overrideAzureMgmtPackage super.azure-mgmt-cosmosdb "0.12.0" "zip"
        "07c0hr7nha9789x1wz0ndca0sr0zscq63m9vd8pm1c6y0ss4iyn5";

      azure-mgmt-deploymentmanager = overrideAzureMgmtPackage super.azure-mgmt-deploymentmanager "0.2.0" "zip"
        "0c6pyr36n9snx879vas5r6l25db6nlp2z96xn759mz4kg4i45qs6";

      azure-mgmt-imagebuilder = overrideAzureMgmtPackage super.azure-mgmt-imagebuilder "0.2.1" "zip"
        "0mwlvy4x5nr3hsz7wdpdhpzwarzzwz4225bfpd68hr0pcjgzspky";

      azure-mgmt-iothub = overrideAzureMgmtPackage super.azure-mgmt-iothub "0.11.0" "zip"
        "11887zf61ji1dh62czrsgxwz8idybw93m6iwahjy777jkdyviyzn";

      azure-mgmt-iotcentral = overrideAzureMgmtPackage super.azure-mgmt-iotcentral "3.0.0" "zip"
        "0iq04hvivq3fvg2lhax95gx0x35avk5hps42227z3qna5i2cznpn";

      azure-mgmt-kusto = overrideAzureMgmtPackage super.azure-mgmt-kusto "0.3.0" "zip"
        "1pmcdgimd66h964a3d5m2j2fbydshcwhrk87wblhwhfl3xwbgf4y";

      azure-mgmt-devtestlabs = overrideAzureMgmtPackage super.azure-mgmt-devtestlabs "2.2.0" "zip"
        "15lpyv9z8ss47rjmg1wx5akh22p9br2vckaj7jk3639vi38ac5nl";

      azure-mgmt-netapp = overrideAzureMgmtPackage super.azure-mgmt-netapp "0.8.0" "zip"
        "0vbg5mpahrnnnbj80flgzxxiffic94wsc9srm4ir85y2j5rprpv7";

      azure-mgmt-dns = overrideAzureMgmtPackage super.azure-mgmt-dns "2.1.0" "zip"
        "1l55py4fzzwhxlmnwa41gpmqk9v2ncc79w7zq11sm9a5ynrv2c1p";

      azure-mgmt-loganalytics = overrideAzureMgmtPackage super.azure-mgmt-loganalytics "0.2.0" "zip"
        "11kx4ck58nhhn9zf5vq0rqh7lfh2yj758s6ainrqyqadxvq5ycf7";

      azure-mgmt-network = overrideAzureMgmtPackage super.azure-mgmt-network "10.1.0" "zip"
        "0fmsdwzyn167lwh87yyadq1bdc4q6rfz3gj5bh1mgavi9ghhxb75";

      azure-mgmt-media = overrideAzureMgmtPackage super.azure-mgmt-media "1.1.1" "zip"
        "16wk0ksycrscsn3n14qk4vvf7i567vq6f96lwf5dwbc81wx6n32x";

      azure-mgmt-msi = overrideAzureMgmtPackage super.azure-mgmt-msi "0.2.0" "zip"
        "0rvik03njz940x2hvqg6iiq8k0d88gyygsr86w8s0sa12sdbq8l6";

      azure-mgmt-web = overrideAzureMgmtPackage super.azure-mgmt-web "0.44.0" "zip"
        "05dqakhfi301k2jnvccxdkigqvwnf9xz858pqg9vsri3dq69f1rw";

      azure-mgmt-redhatopenshift = overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "0.1.0" "zip"
        "1g65lbia1i1jw6qkyjz2ldyl3p90rbr78l8kfryg70sj7z3gnnjn";

      azure-mgmt-redis = overrideAzureMgmtPackage super.azure-mgmt-redis "7.0.0rc1" "zip"
        "086wk31wsl8dx14qpd0g1bly8i9a8fix007djlj9cybva2f2bk6k";

      azure-mgmt-reservations = overrideAzureMgmtPackage super.azure-mgmt-reservations "0.6.0" "zip"
        "16ycni3cjl9c0mv419gy5rgbrlg8zp0vnr6aj8z8p2ypdw6sgac3";

      azure-mgmt-security = overrideAzureMgmtPackage super.azure-mgmt-security "0.1.0" "zip"
        "1cb466722bs0ribrirb32kc299716pl0pwivz3jyn40dd78cwhhx";

      azure-mgmt-sql = overrideAzureMgmtPackage super.azure-mgmt-sql "0.18.0" "zip"
        "0i9lnhcx85xccddvz1wdz5j0idm6sw2cn3066dww5993nmg0ijlr";

      azure-mgmt-sqlvirtualmachine = overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "0.5.0" "zip"
        "1b9am8raa17hxnz7d5pk2ix0309wsnhnchq1mi22icd728sl5adm";

      azure-mgmt-datamigration = overrideAzureMgmtPackage super.azure-mgmt-datamigration "0.1.0" "zip"
        "1pq5rn32yvrf5kqjafnj0kc92gpfg435w2l0k7cm8gvlja4r4m77";

      azure-mgmt-relay = overrideAzureMgmtPackage super.azure-mgmt-relay "0.1.0" "zip"
        "1jss6qhvif8l5s0lblqw3qzijjf0h88agciiydaa7f4q577qgyfr";

      azure-mgmt-eventhub = overrideAzureMgmtPackage super.azure-mgmt-eventhub "3.0.0" "zip"
        "05c6isg13dslds94kv28v6navxj4bp4c5lsd9df0g3ndsxvpdrxp";

      azure-mgmt-keyvault = overrideAzureMgmtPackage super.azure-mgmt-keyvault "2.2.0" "zip"
        "1r5ww9ndya6sifafrbp4cr5iyyaww2ns7wrbqm6hc6aqxcpf30qq";

      azure-mgmt-cdn = overrideAzureMgmtPackage super.azure-mgmt-cdn "4.1.0rc1" "zip"
        "00q5723gvc57kg2w1iyhfchp018skwd89ibrw23p7ngm2bb76g45";

      azure-mgmt-containerregistry = overrideAzureMgmtPackage super.azure-mgmt-containerregistry "3.0.0rc11" "zip"
        "1ixh2wmrbm1v2xlrnmy1l513jpqch6b5vyh9x77flm649x1cff2q";

      azure-mgmt-monitor = overrideAzureMgmtPackage super.azure-mgmt-monitor "0.9.0" "zip"
        "170jyr1qzwhv5ihyrsg5d8qzjylqmg31dscd31jzi4i7bwqf3sb8";

      azure-mgmt-advisor =  overrideAzureMgmtPackage super.azure-mgmt-advisor "2.0.1" "zip"
        "1wsfkprdrn22mwm24y2zlcms8ppp7jwq3s86r3ymbl29pbaxca8r";

      azure-mgmt-applicationinsights = overrideAzureMgmtPackage super.azure-mgmt-applicationinsights "0.1.1" "zip"
        "16raxr5naszrxmgbfhsvh7rqcph5cx6x3f480790m79ykvmjj0pi";

      azure-mgmt-authorization = overrideAzureMgmtPackage super.azure-mgmt-authorization "0.52.0" "zip"
        "0357laxgldb7lvvws81r8xb6mrq9dwwnr1bnwdnyj4bw6p21i9hn";

      azure-mgmt-storage = overrideAzureMgmtPackage super.azure-mgmt-storage "9.0.0" "zip"
        "198r51av2rd1mr3q9j8jibhd14w0v8k59ipc3czsm4g1n44adgkl";

      azure-mgmt-servicefabric = overrideAzureMgmtPackage super.azure-mgmt-servicefabric "0.4.0" "zip"
        "1x18grkjf2p2r1ihlwv607sna9yjvsr2jwnkjc55askrgrwx5jx2";

      azure-mgmt-hdinsight = overrideAzureMgmtPackage super.azure-mgmt-hdinsight "1.4.0" "zip"
        "0zmmfj7z1zrayjqwqybcn3bwm47d2ngyxm1g6fh2iw5c2f9czycv";

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
        pythonNamespaces = [ "azure" ];
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

      knack = super.knack.overridePythonAttrs(oldAttrs: rec {
        version = "0.7.0rc3";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1mazy5a3505wqa68fxq7h55m0vbmjygv2wbgmxmrrrgw3w84q5r7";
        };
      });

    };
  };
in
  py
