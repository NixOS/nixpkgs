
{ pkgs, python, buildPythonPackage }:

let plone42Packages = python.modules // rec {
  inherit python;
  inherit (pkgs) fetchurl stdenv;



  accesscontrol = buildPythonPackage rec {
    name = "AccessControl-2.13.11";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/A/AccessControl/${name}.zip";
      md5 = "7e622d99fb17914b4708d26f245cb696";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  acquisition = buildPythonPackage rec {
    name = "Acquisition-2.13.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/A/Acquisition/${name}.zip";
      md5 = "8c33160c157b50649e2b2b3224622579";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  archetypes_kss = buildPythonPackage rec {
    name = "archetypes.kss-1.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/archetypes.kss/${name}.zip";
      md5 = "a8502140123b74f1b7ed4f36d3e56ff3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  archetypes_querywidget = buildPythonPackage rec {
    name = "archetypes.querywidget-1.0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/archetypes.querywidget/${name}.zip";
      md5 = "cbe134f2806191fd35066bbb7c85bfcc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  archetypes_referencebrowserwidget = buildPythonPackage rec {
    name = "archetypes.referencebrowserwidget-2.4.16";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/archetypes.referencebrowserwidget/${name}.zip";
      md5 = "7dd3b0d4e188828701a291449c7495f4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  archetypes_schemaextender = buildPythonPackage rec {
    name = "archetypes.schemaextender-2.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/archetypes.schemaextender/${name}.zip";
      md5 = "865aa5b4b6b26e3bb650d89ddfe77c87";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  argparse = buildPythonPackage rec {
    name = "argparse-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/argparse/${name}.zip";
      md5 = "087399b73047fa5a6482037411ddc968";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  borg_localrole = buildPythonPackage rec {
    name = "borg.localrole-3.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/borg.localrole/${name}.zip";
      md5 = "04082694dfda9ae5cda62747b8ac7ccf";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  buildout_dumppickedversions = buildPythonPackage rec {
    name = "buildout.dumppickedversions-0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/buildout.dumppickedversions/${name}.tar.gz";
      md5 = "e81cffff329aaaaf8dd0d1c6bd63c8b0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  clientform = buildPythonPackage rec {
    name = "ClientForm-0.2.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/C/ClientForm/${name}.zip";
      md5 = "33826886848f89c67a5c8a30b931bd97";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_monkeypatcher = buildPythonPackage rec {
    name = "collective.monkeypatcher-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.monkeypatcher/${name}.zip";
      md5 = "4d4f20f9b8bb84b24afadc4f56f6dc2c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_recipe_omelette = buildPythonPackage rec {
    name = "collective.recipe.omelette-0.15";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.recipe.omelette/${name}.zip";
      md5 = "088bcf60754bead215573ce114207939";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_testcaselayer = buildPythonPackage rec {
    name = "collective.testcaselayer-1.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.testcaselayer/${name}.zip";
      md5 = "fd8387d6b6ebd8645ec92f5f1e512450";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_xmltestreport = buildPythonPackage rec {
    name = "collective.xmltestreport-1.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.xmltestreport/${name}.tar.gz";
      md5 = "f247d47a019b44694660d785f70c05b3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_z3cform_datagridfield = buildPythonPackage rec {
    name = "collective.z3cform.datagridfield-0.11";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.z3cform.datagridfield/${name}.zip";
      md5 = "c9210337b91305314864da42c12d04c2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_z3cform_datagridfield_demo = buildPythonPackage rec {
    name = "collective.z3cform.datagridfield-demo-0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.z3cform.datagridfield/collective.z3cform.datagridfield-0.11.zip";
      md5 = "c9210337b91305314864da42c12d04c2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  collective_z3cform_datetimewidget = buildPythonPackage rec {
    name = "collective.z3cform.datetimewidget-1.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/collective.z3cform.datetimewidget/${name}.zip";
      md5 = "89daf27c7f0f235f9c001f0ee50d76e5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  coverage = buildPythonPackage rec {
    name = "coverage-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/coverage/${name}.tar.gz";
      md5 = "28c43d41b13f8987ea14d7b1d4a4e3ec";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  datetime = buildPythonPackage rec {
    name = "DateTime-2.12.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/D/DateTime/${name}.zip";
      md5 = "72a8bcf80b52211ae7fdfe36c693d70c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  diazo = buildPythonPackage rec {
    name = "diazo-1.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/diazo/${name}.zip";
      md5 = "d3c2b017af521db4c86fb360c86e0bc8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  documenttemplate = buildPythonPackage rec {
    name = "DocumentTemplate-2.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/D/DocumentTemplate/${name}.zip";
      md5 = "07bb086c77c1dfe94125ad2efbba94b7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  docutils = buildPythonPackage rec {
    name = "docutils-0.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/docutils/${name}.1.tar.gz";
      md5 = "b0d5cd5298fedf9c62f5fd364a274d56";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  elementtree = buildPythonPackage rec {
    name = "elementtree-1.2.7-20070827-preview";

    src = fetchurl {
      url = "http://effbot.org/media/downloads/elementtree-1.2.7-20070827-preview.zip";
      md5 = "30e2fe5edd143f347e03a8baf5d60f8a";
    };

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  experimental_cssselect = buildPythonPackage rec {
    name = "experimental.cssselect-0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/experimental.cssselect/${name}.zip";
      md5 = "3fecdcf1fbc3ea6025e115a56a262957";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  extensionclass = buildPythonPackage rec {
    name = "ExtensionClass-2.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/E/ExtensionClass/${name}.zip";
      md5 = "0236e6d7da9e8b87b9ba45f1b8f930b8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  feedparser = buildPythonPackage rec {
    name = "feedparser-5.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/feedparser/${name}.tar.bz2";
      md5 = "702835de74bd4a578524f311e62c2877";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  five_customerize = buildPythonPackage rec {
    name = "five.customerize-1.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/five.customerize/${name}.zip";
      md5 = "32f597c2fa961f7dcc84b23e655d928e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  five_formlib = buildPythonPackage rec {
    name = "five.formlib-1.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/five.formlib/${name}.zip";
      md5 = "09fcecbb7e0ed4a31a4f19787c1a78b4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  five_globalrequest = buildPythonPackage rec {
    name = "five.globalrequest-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/five.globalrequest/${name}.tar.gz";
      md5 = "87f8996bd21d4aa156aa26e7d21b8744";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  five_grok = buildPythonPackage rec {
    name = "five.grok-1.2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/five.grok/${name}.zip";
      md5 = "b99c3017f3a487dc2a8b7b0b310ee8cf";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  five_intid = buildPythonPackage rec {
    name = "five.intid-1.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/five.intid/${name}.zip";
      md5 = "60c6726c07a1c1bf557aeec0ddcee369";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  five_localsitemanager = buildPythonPackage rec {
    name = "five.localsitemanager-2.0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/five.localsitemanager/${name}.zip";
      md5 = "5e3a658e6068832bd802018ebc83f2d4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_annotation = buildPythonPackage rec {
    name = "grokcore.annotation-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.annotation/${name}.tar.gz";
      md5 = "a28ccb4b7c86198923d9cce40953314f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_component = buildPythonPackage rec {
    name = "grokcore.component-1.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.component/${name}.tar.gz";
      md5 = "24b05b6b132787dbca18acd244c23ffb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_formlib = buildPythonPackage rec {
    name = "grokcore.formlib-1.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.formlib/${name}.tar.gz";
      md5 = "dced4aba77053ed78a358a1f5e85d9c4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_security = buildPythonPackage rec {
    name = "grokcore.security-1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.security/${name}.tar.gz";
      md5 = "1e668b7e423814fa069c69f2a4014876";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_site = buildPythonPackage rec {
    name = "grokcore.site-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.site/${name}.tar.gz";
      md5 = "bd16753e6d4f1c0ff38266d2ae79633d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_view = buildPythonPackage rec {
    name = "grokcore.view-1.13.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.view/${name}.tar.gz";
      md5 = "304363398aa752d5e1479bab39b93e4e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  grokcore_viewlet = buildPythonPackage rec {
    name = "grokcore.viewlet-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grokcore.viewlet/${name}.tar.gz";
      md5 = "5e53b3c77941f9ad0ff2aeb7c1b6dd7d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  initgroups = buildPythonPackage rec {
    name = "initgroups-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/i/initgroups/${name}.zip";
      md5 = "38e842dcab8445f65e701fec75213acd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  jinja2 = buildPythonPackage rec {
    name = "Jinja2-2.5.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/${name}.tar.gz";
      md5 = "83b20c1eeb31f49d8e6392efae91b7d5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  kss_core = buildPythonPackage rec {
    name = "kss.core-1.6.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/k/kss.core/${name}.zip";
      md5 = "87e66e78c3bbd7af3ecce5b2fef935ae";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  mailinglogger = buildPythonPackage rec {
    name = "mailinglogger-3.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mailinglogger/${name}.tar.gz";
      md5 = "f865f0df6059ce23062b7457d01dbac5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  manuel = buildPythonPackage rec {
    name = "manuel-1.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/manuel/${name}.tar.gz";
      md5 = "8cd560cf6e8720ecb129c4e5be605fbb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  markdown = buildPythonPackage rec {
    name = "Markdown-2.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/Markdown/${name}.zip";
      md5 = "122418893e21e91109edbf6e082f830d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  martian = buildPythonPackage rec {
    name = "martian-0.11.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/martian/${name}.tar.gz";
      md5 = "865646fcd9dd31613204d5f4c2db943b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  mechanize = buildPythonPackage rec {
    name = "mechanize-0.2.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mechanize/${name}.zip";
      md5 = "a497ad4e875f7506ffcf8ad3ada4c2fc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  missing = buildPythonPackage rec {
    name = "Missing-2.13.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/Missing/${name}.zip";
      md5 = "9823cff54444cbbcaef8fc45d8e42572";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  mocker = buildPythonPackage rec {
    name = "mocker-1.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mocker/${name}.tar.bz2";
      md5 = "0bd9f83268e16aef2130fa89e2a4839f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  mr_developer = buildPythonPackage rec {
    name = "mr.developer-1.21";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mr.developer/${name}.zip";
      md5 = "5f832f1709714b09cd7490603afd2365";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  multimapping = buildPythonPackage rec {
    name = "MultiMapping-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/MultiMapping/${name}.zip";
      md5 = "d69c5904c105b9f2f085d4103e0f0586";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  nose = buildPythonPackage rec {
    name = "nose-1.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
      md5 = "144f237b615e23f21f6a50b2183aa817";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  nt_svcutils = buildPythonPackage rec {
    name = "nt-svcutils-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/nose-1.1.2.tar.gz";
      md5 = "144f237b615e23f21f6a50b2183aa817";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  ordereddict = buildPythonPackage rec {
    name = "ordereddict-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/o/ordereddict/${name}.tar.gz";
      md5 = "a0ed854ee442051b249bfad0f638bbec";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  paste = buildPythonPackage rec {
    name = "Paste-1.7.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Paste/${name}.tar.gz";
      md5 = "7ea5fabed7dca48eb46dc613c4b6c4ed";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  pastedeploy = buildPythonPackage rec {
    name = "PasteDeploy-1.3.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteDeploy/${name}.tar.gz";
      md5 = "eb4b3e2543d54401249c2cbd9f2d014f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  pastescript = buildPythonPackage rec {
    name = "PasteScript-1.7.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteScript/${name}.tar.gz";
      md5 = "4c72d78dcb6bb993f30536842c16af4d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ paste pastedeploy ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  persistence = buildPythonPackage rec {
    name = "Persistence-2.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Persistence/${name}.zip";
      md5 = "92693648ccdc59c8fc71f7f06b1d228c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  pil = buildPythonPackage rec {
    name = "PIL-1.1.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Persistence/Persistence-2.13.2.zip";
      md5 = "92693648ccdc59c8fc71f7f06b1d228c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone = buildPythonPackage rec {
    name = "Plone-4.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Plone/${name}.zip";
      md5 = "688438bd541e7cb2ab650c8c59282b85";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_alterego = buildPythonPackage rec {
    name = "plone.alterego-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.alterego/${name}.zip";
      md5 = "b7b6dbcbba00505d98d5aba83e016408";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_blob = buildPythonPackage rec {
    name = "plone.app.blob-1.5.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.blob/${name}.zip";
      md5 = "8d6ba6f360b6bfd40f87914132339660";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_caching = buildPythonPackage rec {
    name = "plone.app.caching-1.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.caching/${name}.zip";
      md5 = "83a52efeb7604d4c5b4afbc6c1365c6f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_collection = buildPythonPackage rec {
    name = "plone.app.collection-1.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.collection/${name}.zip";
      md5 = "40c9035472e386fc9d0ec1b9a9a3d4f6";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_content = buildPythonPackage rec {
    name = "plone.app.content-2.0.12";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.content/${name}.zip";
      md5 = "2f14a85fb66d73e0b699b839caaaad26";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_contentlisting = buildPythonPackage rec {
    name = "plone.app.contentlisting-1.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.contentlisting/${name}.zip";
      md5 = "fa6eb45c4ffd0eb3817ad4813ca24916";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_contentmenu = buildPythonPackage rec {
    name = "plone.app.contentmenu-2.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.contentmenu/${name}.zip";
      md5 = "b1c7e5a37c659ba30b3a077e149b1752";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_contentrules = buildPythonPackage rec {
    name = "plone.app.contentrules-2.1.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.contentrules/${name}.zip";
      md5 = "74d2fed9095a7c5f890b6f27de78dafc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_controlpanel = buildPythonPackage rec {
    name = "plone.app.controlpanel-2.2.11";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.controlpanel/${name}.zip";
      md5 = "401c8880865f398c281953f5837108b9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_customerize = buildPythonPackage rec {
    name = "plone.app.customerize-1.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.customerize/${name}.zip";
      md5 = "6a3802c4e8fbd955597adc6a8298febf";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_dexterity = buildPythonPackage rec {
    name = "plone.app.dexterity-1.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.dexterity/${name}.zip";
      md5 = "25ccd382f9e08cfdfe4a9b7e455030bc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_discussion = buildPythonPackage rec {
    name = "plone.app.discussion-2.1.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.discussion/${name}.zip";
      md5 = "b0cb1fbdf8a7a238cf5a58fb10c24731";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_folder = buildPythonPackage rec {
    name = "plone.app.folder-1.0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.folder/${name}.zip";
      md5 = "8ea860daddb4c93c0b7f2b5f7106fef0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_form = buildPythonPackage rec {
    name = "plone.app.form-2.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.form/${name}.zip";
      md5 = "8017f8f782d992825ed71d16b126c4e7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_i18n = buildPythonPackage rec {
    name = "plone.app.i18n-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.i18n/${name}.zip";
      md5 = "a10026573463dfc1899bf4062cebdbf2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_imaging = buildPythonPackage rec {
    name = "plone.app.imaging-1.0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.imaging/${name}.zip";
      md5 = "8d494cd69b3f6be7fcb9e21c20277765";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_intid = buildPythonPackage rec {
    name = "plone.app.intid-1.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.intid/${name}.tar.gz";
      md5 = "863077002bd272ff11c47de0f7f9db1a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_iterate = buildPythonPackage rec {
    name = "plone.app.iterate-2.1.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.iterate/${name}.zip";
      md5 = "db598cfc0986737145ddc7e6b70a1794";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_jquery = buildPythonPackage rec {
    name = "plone.app.jquery-1.4.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.jquery/${name}.zip";
      md5 = "a12d56f3dfd2ba6840bf21a6bd860b90";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_jquerytools = buildPythonPackage rec {
    name = "plone.app.jquerytools-1.3.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.jquerytools/${name}.zip";
      md5 = "326470a34e07aa98c40d75ec22484572";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_kss = buildPythonPackage rec {
    name = "plone.app.kss-1.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.kss/${name}.zip";
      md5 = "97a35086fecfe25e55b65042eb35e796";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_layout = buildPythonPackage rec {
    name = "plone.app.layout-2.2.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.layout/${name}.zip";
      md5 = "90ea408f5e01aeb01517d55eb6b6063a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_linkintegrity = buildPythonPackage rec {
    name = "plone.app.linkintegrity-1.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.linkintegrity/${name}.zip";
      md5 = "41810cc85ca05921a329aac5bc4cf403";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_locales = buildPythonPackage rec {
    name = "plone.app.locales-4.2.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.locales/${name}.zip";
      md5 = "baf48a0a5278a18fa1c2848d3470464f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_lockingbehavior = buildPythonPackage rec {
    name = "plone.app.lockingbehavior-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.lockingbehavior/${name}.tar.gz";
      md5 = "a25745f1f40c6298da1b228ccd95ee27";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_openid = buildPythonPackage rec {
    name = "plone.app.openid-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.openid/${name}.tar.gz";
      md5 = "ae0748f91cab0612a498926d405d8edd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_portlets = buildPythonPackage rec {
    name = "plone.app.portlets-2.3.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.portlets/${name}.zip";
      md5 = "534be67a7a17a71ca1e76f6f149ff2ac";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_querystring = buildPythonPackage rec {
    name = "plone.app.querystring-1.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.querystring/${name}.zip";
      md5 = "b501910b23def9b58e8309d1e469eb6f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_redirector = buildPythonPackage rec {
    name = "plone.app.redirector-1.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.redirector/${name}.zip";
      md5 = "7d441340a83b8ed72a03bc16148a5f21";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_referenceablebehavior = buildPythonPackage rec {
    name = "plone.app.referenceablebehavior-0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.referenceablebehavior/${name}.zip";
      md5 = "2359140966f753204d5091bb49fce85c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_registry = buildPythonPackage rec {
    name = "plone.app.registry-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.registry/${name}.zip";
      md5 = "0fdbb01e9ff71108f1be262c39b41b81";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_relationfield = buildPythonPackage rec {
    name = "plone.app.relationfield-1.2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.relationfield/${name}.zip";
      md5 = "d19888741677cd457ac7f22dde97ded0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_search = buildPythonPackage rec {
    name = "plone.app.search-1.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.search/${name}.zip";
      md5 = "bd5a1f4b5016a6d0a8697e7a9cc04833";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_stagingbehavior = buildPythonPackage rec {
    name = "plone.app.stagingbehavior-0.1b4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.stagingbehavior/${name}.zip";
      md5 = "0f9589ec056c303ea0c81a804dd411eb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_testing = buildPythonPackage rec {
    name = "plone.app.testing-4.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.testing/${name}.zip";
      md5 = "1a40df72c8beda9520b83dc449a97a3c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_textfield = buildPythonPackage rec {
    name = "plone.app.textfield-1.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.textfield/${name}.zip";
      md5 = "f832887a40826d6f68c48b48f071fb9c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_theming = buildPythonPackage rec {
    name = "plone.app.theming-1.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.theming/${name}.zip";
      md5 = "2da6d810e0d5f295dd0daa2b60731a1b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_upgrade = buildPythonPackage rec {
    name = "plone.app.upgrade-1.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.upgrade/${name}.zip";
      md5 = "2798dd50863d8c25624400b988a0acdd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_users = buildPythonPackage rec {
    name = "plone.app.users-1.1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.users/${name}.zip";
      md5 = "97895d8dbdf885784be1afbf5b8b364c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_uuid = buildPythonPackage rec {
    name = "plone.app.uuid-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.uuid/${name}.zip";
      md5 = "9ca8dcfb09a8a0d6bbee0f28073c3d3f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_versioningbehavior = buildPythonPackage rec {
    name = "plone.app.versioningbehavior-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.versioningbehavior/${name}.zip";
      md5 = "6c153e3fa10b9ffea9742d0dad7b3b85";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_viewletmanager = buildPythonPackage rec {
    name = "plone.app.viewletmanager-2.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.viewletmanager/${name}.zip";
      md5 = "1dbc51c7664ce3e6ca4dcca1b7b86082";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_vocabularies = buildPythonPackage rec {
    name = "plone.app.vocabularies-2.1.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.vocabularies/${name}.zip";
      md5 = "34d4eb9c95879811fec0875aa3235ed3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_workflow = buildPythonPackage rec {
    name = "plone.app.workflow-2.0.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.workflow/${name}.zip";
      md5 = "350ea680ccf7eb9b1598927cafad4f38";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_app_z3cform = buildPythonPackage rec {
    name = "plone.app.z3cform-0.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.app.z3cform/${name}.zip";
      md5 = "2e77f5e03d48a6fb2eb9994edb871917";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_autoform = buildPythonPackage rec {
    name = "plone.autoform-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.autoform/${name}.zip";
      md5 = "4cb2935ba9cda3eb3ee801ad8cda7c60";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_behavior = buildPythonPackage rec {
    name = "plone.behavior-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.behavior/${name}.zip";
      md5 = "a18feb9ec744b2a64028c366a8835d59";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_browserlayer = buildPythonPackage rec {
    name = "plone.browserlayer-2.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.browserlayer/${name}.zip";
      md5 = "bce02f4907a4f29314090c525e5fc28e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_cachepurging = buildPythonPackage rec {
    name = "plone.cachepurging-1.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.cachepurging/${name}.zip";
      md5 = "886814ac4deef0f1ed99a2eb60864264";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_caching = buildPythonPackage rec {
    name = "plone.caching-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.caching/${name}.zip";
      md5 = "2c2e3b27d13b9101c92dfed222fde36c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_contentrules = buildPythonPackage rec {
    name = "plone.contentrules-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.contentrules/${name}.zip";
      md5 = "a32370656c4fd58652fcd8a234db69c5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_dexterity = buildPythonPackage rec {
    name = "plone.dexterity-1.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.dexterity/${name}.zip";
      md5 = "c8f495e368ada3a4566d99995d09e64c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_directives_dexterity = buildPythonPackage rec {
    name = "plone.directives.dexterity-1.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.directives.dexterity/${name}.zip";
      md5 = "713b87644e3591b60b4a8ebd52987477";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_directives_form = buildPythonPackage rec {
    name = "plone.directives.form-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.directives.form/${name}.zip";
      md5 = "e40a4b3fdde3768a137a450374934565";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_fieldsets = buildPythonPackage rec {
    name = "plone.fieldsets-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.fieldsets/${name}.zip";
      md5 = "4158c8a1f784fcb5cecbd63deda7222f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_folder = buildPythonPackage rec {
    name = "plone.folder-1.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.folder/${name}.zip";
      md5 = "1674ff18b7a9452d0c2063cf11c679b7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_formwidget_autocomplete = buildPythonPackage rec {
    name = "plone.formwidget.autocomplete-1.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.formwidget.autocomplete/${name}.zip";
      md5 = "06b3bfed9ea51fe2e93827f539fc7f07";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_formwidget_contenttree = buildPythonPackage rec {
    name = "plone.formwidget.contenttree-1.0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.formwidget.contenttree/${name}.zip";
      md5 = "2ea222d53ca856de7c6df831707f4ac1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_formwidget_namedfile = buildPythonPackage rec {
    name = "plone.formwidget.namedfile-1.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.formwidget.namedfile/${name}.zip";
      md5 = "9274db2f5d7b4d07748fabfd125e49d0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_i18n = buildPythonPackage rec {
    name = "plone.i18n-2.0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.i18n/${name}.zip";
      md5 = "ef36aa9a294d507abb37787f9f7700bd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_indexer = buildPythonPackage rec {
    name = "plone.indexer-1.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.indexer/${name}.zip";
      md5 = "538aeee1f9db78bc8c85ae1bcb0153ed";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_intelligenttext = buildPythonPackage rec {
    name = "plone.intelligenttext-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.intelligenttext/${name}.zip";
      md5 = "51688fa0815b49e00334e3ef948328ba";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_keyring = buildPythonPackage rec {
    name = "plone.keyring-2.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.keyring/${name}.zip";
      md5 = "f3970e9bddb2cc65e461a2c62879233f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_locking = buildPythonPackage rec {
    name = "plone.locking-2.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.locking/${name}.zip";
      md5 = "a7f8b8db78f57272d351d7fe0d067eb2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_memoize = buildPythonPackage rec {
    name = "plone.memoize-1.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.memoize/${name}.zip";
      md5 = "d07cd14b976160e1f26a859e3370147e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_mocktestcase = buildPythonPackage rec {
    name = "plone.mocktestcase-1.0b3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.mocktestcase/${name}.tar.gz";
      md5 = "6de66da6d610537d1f5c31e2ab0f36ee";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_namedfile = buildPythonPackage rec {
    name = "plone.namedfile-1.0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.namedfile/${name}.zip";
      md5 = "06f5bfa7079f889307ac5760e4cb4a7b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_openid = buildPythonPackage rec {
    name = "plone.openid-2.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.openid/${name}.zip";
      md5 = "d4c36926a6dbefed035ed92c29329ce1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_outputfilters = buildPythonPackage rec {
    name = "plone.outputfilters-1.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.outputfilters/${name}.zip";
      md5 = "a5ef28580f7fa7f2dc1768893995b0f7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_portlet_collection = buildPythonPackage rec {
    name = "plone.portlet.collection-2.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.portlet.collection/${name}.zip";
      md5 = "5f0006dbb3e0b56870383dfdedc49228";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_portlet_static = buildPythonPackage rec {
    name = "plone.portlet.static-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.portlet.static/${name}.zip";
      md5 = "ec0dc691b4191a41ff97779b117f9985";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_portlets = buildPythonPackage rec {
    name = "plone.portlets-2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.portlets/${name}.zip";
      md5 = "12b9a33f787756a48617c2d2dd63c538";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_protect = buildPythonPackage rec {
    name = "plone.protect-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.protect/${name}.zip";
      md5 = "74925ffb08782e72f9b1e850fa78fffa";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_recipe_alltests = buildPythonPackage rec {
    name = "plone.recipe.alltests-1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.recipe.alltests/${name}.zip";
      md5 = "c4ba0f67a2fdd259bd0e7d946bd35674";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_recipe_zeoserver = buildPythonPackage rec {
    name = "plone.recipe.zeoserver-1.2.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.recipe.zeoserver/${name}.zip";
      md5 = "cd58899a7d534fe2d0ef42990a07c499";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_registry = buildPythonPackage rec {
    name = "plone.registry-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.registry/${name}.zip";
      md5 = "6be3d2ec7e2d170e29b8c0bc65049aff";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_reload = buildPythonPackage rec {
    name = "plone.reload-2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.reload/${name}.zip";
      md5 = "49eab593c81b78a9b80d54786aa4ad72";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_resource = buildPythonPackage rec {
    name = "plone.resource-1.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.resource/${name}.zip";
      md5 = "594d41e3acd913ae92f2e9ef96503b9f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_rfc822 = buildPythonPackage rec {
    name = "plone.rfc822-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.rfc822/${name}.zip";
      md5 = "b5b79bb5a9181da624a7e88940a45424";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_scale = buildPythonPackage rec {
    name = "plone.scale-1.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.scale/${name}.zip";
      md5 = "7c59522b4806ee24f5e0a5fa69c523a5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_schemaeditor = buildPythonPackage rec {
    name = "plone.schemaeditor-1.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.schemaeditor/${name}.zip";
      md5 = "0b0fb4b20d9463b3fef82c2079a897d7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_session = buildPythonPackage rec {
    name = "plone.session-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.session/${name}.zip";
      md5 = "2f9d3b88e813a47135af56a4da8bbde1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_stringinterp = buildPythonPackage rec {
    name = "plone.stringinterp-1.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.stringinterp/${name}.zip";
      md5 = "81909716210c6ac3fd0ee87f45ea523d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_subrequest = buildPythonPackage rec {
    name = "plone.subrequest-1.6.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.subrequest/${name}.zip";
      md5 = "cc12f68a22565415b10dbeef0020baa4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_supermodel = buildPythonPackage rec {
    name = "plone.supermodel-1.1.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.supermodel/${name}.zip";
      md5 = "00b3d723bb1a48116fe3bf8754f17085";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_synchronize = buildPythonPackage rec {
    name = "plone.synchronize-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.synchronize/${name}.zip";
      md5 = "d25e86ace8daa0816861296c3288c4fb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_testing = buildPythonPackage rec {
    name = "plone.testing-4.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.testing/${name}.zip";
      md5 = "fa40f6d3e3e254409c486c1c2c3e8804";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_theme = buildPythonPackage rec {
    name = "plone.theme-2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.theme/${name}.zip";
      md5 = "c592d0d095e9fc76cc81597cdf6d0c37";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_transformchain = buildPythonPackage rec {
    name = "plone.transformchain-1.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.transformchain/${name}.zip";
      md5 = "f5fb7ca894249e3e666501c4fae52a6c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_uuid = buildPythonPackage rec {
    name = "plone.uuid-1.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.uuid/${name}.zip";
      md5 = "183fe2911a7d6c9f6b3103855e98ad8a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plone_z3cform = buildPythonPackage rec {
    name = "plone.z3cform-0.7.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plone.z3cform/${name}.zip";
      md5 = "da891365156a5d5824d4e504465886a2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plonetheme_classic = buildPythonPackage rec {
    name = "plonetheme.classic-1.2.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plonetheme.classic/${name}.zip";
      md5 = "9dc15871937f9cdf94cdfdb9be77a221";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  plonetheme_sunburst = buildPythonPackage rec {
    name = "plonetheme.sunburst-1.2.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/plonetheme.sunburst/${name}.zip";
      md5 = "be02660c869e04ac8cf6ade3559f2516";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_archetypes = buildPythonPackage rec {
    name = "Products.Archetypes-1.8.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.Archetypes/${name}.zip";
      md5 = "74be68879b27228c084a9be869132a98";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_atcontenttypes = buildPythonPackage rec {
    name = "Products.ATContentTypes-2.1.11";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ATContentTypes/${name}.zip";
      md5 = "abfb5209ffa11dc2c1a15c488e75d89c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_atreferencebrowserwidget = buildPythonPackage rec {
    name = "Products.ATReferenceBrowserWidget-3.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ATReferenceBrowserWidget/${name}.zip";
      md5 = "157bdd32155c8353450c17c649aad042";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_btreefolder2 = buildPythonPackage rec {
    name = "Products.BTreeFolder2-2.13.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.BTreeFolder2/${name}.tar.gz";
      md5 = "f57c85673036af7ccd34c3fa251f6bb2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfactionicons = buildPythonPackage rec {
    name = "Products.CMFActionIcons-2.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFActionIcons/${name}.tar.gz";
      md5 = "ab1dc62404ed11aea84dc0d782b2235e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ eggtestinfo ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfcalendar = buildPythonPackage rec {
    name = "Products.CMFCalendar-2.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFCalendar/${name}.tar.gz";
      md5 = "49458e68dc3b6826ea9a3576ac014419";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ eggtestinfo ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfcore = buildPythonPackage rec {
    name = "Products.CMFCore-2.2.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFCore/${name}.tar.gz";
      md5 = "9320a4023b8575097feacfd4a400e930";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfdefault = buildPythonPackage rec {
    name = "Products.CMFDefault-2.2.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFDefault/${name}.tar.gz";
      md5 = "fe7d2d3906ee0e3b484e4a02401576ab";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ eggtestinfo ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfdifftool = buildPythonPackage rec {
    name = "Products.CMFDiffTool-2.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFDiffTool/${name}.zip";
      md5 = "7b7ed9b8f7b4f438e92e299823f92c86";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfdynamicviewfti = buildPythonPackage rec {
    name = "Products.CMFDynamicViewFTI-4.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFDynamicViewFTI/${name}.zip";
      md5 = "7d39d416b41b2d93954bc73d9d0e077f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfeditions = buildPythonPackage rec {
    name = "Products.CMFEditions-2.2.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFEditions/${name}.zip";
      md5 = "7dc744b3b896c1b212d9ba37b1752b65";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfformcontroller = buildPythonPackage rec {
    name = "Products.CMFFormController-3.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFFormController/${name}.zip";
      md5 = "6573df7dcb39e3b63ba22abe2acd639e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfplacefulworkflow = buildPythonPackage rec {
    name = "Products.CMFPlacefulWorkflow-1.5.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFPlacefulWorkflow/${name}.zip";
      md5 = "9041e1f52eab5b348c0dfa85be438722";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfplone = buildPythonPackage rec {
    name = "Products.CMFPlone-4.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFPlone/${name}.zip";
      md5 = "9c9663cb2b68c07e3d9a2fceaa97eaa1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfquickinstallertool = buildPythonPackage rec {
    name = "Products.CMFQuickInstallerTool-3.0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFQuickInstallerTool/${name}.tar.gz";
      md5 = "af34adb87ddf2b6da48eff8b70ca2989";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmftestcase = buildPythonPackage rec {
    name = "Products.CMFTestCase-0.9.12";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFTestCase/${name}.zip";
      md5 = "fbfdfe7bdb2158419d9899b4ab8c43eb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmftopic = buildPythonPackage rec {
    name = "Products.CMFTopic-2.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFTopic/${name}.tar.gz";
      md5 = "4abeeaafe6b6b1d2f2936bf5431cccba";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ eggtestinfo ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_cmfuid = buildPythonPackage rec {
    name = "Products.CMFUid-2.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.CMFUid/${name}.tar.gz";
      md5 = "e20727959351dffbf0bac80613eee110";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ eggtestinfo ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_contentmigration = buildPythonPackage rec {
    name = "Products.contentmigration-2.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.contentmigration/${name}.zip";
      md5 = "1cef33faec03e655b7c52c317db50ed2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_dcworkflow = buildPythonPackage rec {
    name = "Products.DCWorkflow-2.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.DCWorkflow/${name}.tar.gz";
      md5 = "c90a16c4f3611015592ba8173a5f1863";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    propagatedBuildInputs = [ eggtestinfo ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_extendedpathindex = buildPythonPackage rec {
    name = "Products.ExtendedPathIndex-3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ExtendedPathIndex/${name}.zip";
      md5 = "00c048a4b103200bdcbda61fa22c66df";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_externaleditor = buildPythonPackage rec {
    name = "Products.ExternalEditor-1.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ExternalEditor/${name}.zip";
      md5 = "475fea6e0b958c0c51cfdbfef2f4e623";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_externalmethod = buildPythonPackage rec {
    name = "Products.ExternalMethod-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ExternalMethod/${name}.zip";
      md5 = "15ba953ef6cb632eb571977651252ea6";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_genericsetup = buildPythonPackage rec {
    name = "Products.GenericSetup-1.7.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.GenericSetup/${name}.tar.gz";
      md5 = "c48967c81c880ed33ee16a14caab3b11";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_i18ntestcase = buildPythonPackage rec {
    name = "Products.i18ntestcase-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.i18ntestcase/${name}.zip";
      md5 = "f72f72e573975f15adfabfeef34fd721";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_kupu = buildPythonPackage rec {
    name = "Products.kupu-1.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.kupu/${name}.zip";
      md5 = "b884fcc7f510426974d8d3c4333da4f4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_mailhost = buildPythonPackage rec {
    name = "Products.MailHost-2.13.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.MailHost/${name}.zip";
      md5 = "1102e523435d8bf78a15b9ddb57478e1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_marshall = buildPythonPackage rec {
    name = "Products.Marshall-2.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.Marshall/${name}.zip";
      md5 = "bde4d7f75195c1ded8371554b04d2541";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_mimetools = buildPythonPackage rec {
    name = "Products.MIMETools-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.MIMETools/${name}.zip";
      md5 = "ad5372fc1190599a19493db0864448ec";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_mimetypesregistry = buildPythonPackage rec {
    name = "Products.MimetypesRegistry-2.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.MimetypesRegistry/${name}.zip";
      md5 = "898166bb2aaececc8238ad4ee4826793";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_ofsp = buildPythonPackage rec {
    name = "Products.OFSP-2.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.OFSP/${name}.zip";
      md5 = "c76d40928753c2ee56db873304e65bd5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_passwordresettool = buildPythonPackage rec {
    name = "Products.PasswordResetTool-2.0.11";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PasswordResetTool/${name}.zip";
      md5 = "8dfd65f06c3f4a4b0742d1b44b65f014";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_placelesstranslationservice = buildPythonPackage rec {
    name = "Products.PlacelessTranslationService-2.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PlacelessTranslationService/${name}.zip";
      md5 = "a94635eb712563c5a002520713f5d6dc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_plonelanguagetool = buildPythonPackage rec {
    name = "Products.PloneLanguageTool-3.2.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PloneLanguageTool/${name}.zip";
      md5 = "bd9eb6278bf76e8cbce99437ca362164";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_plonepas = buildPythonPackage rec {
    name = "Products.PlonePAS-4.0.15";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PlonePAS/${name}.zip";
      md5 = "c19241b558c994ff280a2e1f50aa1f19";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_plonetestcase = buildPythonPackage rec {
    name = "Products.PloneTestCase-0.9.15";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PloneTestCase/${name}.zip";
      md5 = "ddd5810937919ab5233ebd64893c8bae";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_pluggableauthservice = buildPythonPackage rec {
    name = "Products.PluggableAuthService-1.9.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PluggableAuthService/${name}.tar.gz";
      md5 = "f78f16e46d016c2848bc84254fa66596";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_pluginregistry = buildPythonPackage rec {
    name = "Products.PluginRegistry-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PluginRegistry/${name}.tar.gz";
      md5 = "5b166193ca1eb84dfb402051f779ebab";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_portaltransforms = buildPythonPackage rec {
    name = "Products.PortalTransforms-2.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PortalTransforms/${name}.zip";
      md5 = "9f429f3c3b9e0019d0f6c9b7a8a9376e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_pythonscripts = buildPythonPackage rec {
    name = "Products.PythonScripts-2.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.PythonScripts/${name}.zip";
      md5 = "04c86f2c45a29a162297a80dac61d14f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_resourceregistries = buildPythonPackage rec {
    name = "Products.ResourceRegistries-2.2.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ResourceRegistries/${name}.zip";
      md5 = "9cf6efbcf2a6510033c06e1d3af94080";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_securemailhost = buildPythonPackage rec {
    name = "Products.SecureMailHost-1.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.SecureMailHost/${name}.zip";
      md5 = "7db0f1fa867bd0df972082f502a7a707";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_standardcachemanagers = buildPythonPackage rec {
    name = "Products.StandardCacheManagers-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.StandardCacheManagers/${name}.zip";
      md5 = "c5088b2b62bd26d63d9579a04369cb73";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_statusmessages = buildPythonPackage rec {
    name = "Products.statusmessages-4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.statusmessages/${name}.zip";
      md5 = "265324b0a58a032dd0ed038103ed0473";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_tinymce = buildPythonPackage rec {
    name = "Products.TinyMCE-1.2.15";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.TinyMCE/${name}.zip";
      md5 = "108b919bfcff711d2116e41eccbede58";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_validation = buildPythonPackage rec {
    name = "Products.validation-2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.validation/${name}.zip";
      md5 = "afa217e2306637d1dccbebf337caa8bf";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_zcatalog = buildPythonPackage rec {
    name = "Products.ZCatalog-2.13.23";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ZCatalog/${name}.zip";
      md5 = "d425171516dfc70e543a4e2b852301cb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_zctextindex = buildPythonPackage rec {
    name = "Products.ZCTextIndex-2.13.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ZCTextIndex/${name}.zip";
      md5 = "8bbfa5fcd3609246990a9314d6f826b4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_zopeversioncontrol = buildPythonPackage rec {
    name = "Products.ZopeVersionControl-1.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ZopeVersionControl/${name}.zip";
      md5 = "238239102f3ac798ee4f4c53343a561f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  products_zsqlmethods = buildPythonPackage rec {
    name = "Products.ZSQLMethods-2.13.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Products.ZSQLMethods/${name}.zip";
      md5 = "bd1ad8fd4a9d4f8b4681401dd5b71dc1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  py = buildPythonPackage rec {
    name = "py-1.3.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/py/${name}.tar.gz";
      md5 = "b64d73a04121c1c4e27c7ec335ef87c8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  pygments = buildPythonPackage rec {
    name = "Pygments-1.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pygments/${name}.tar.gz";
      md5 = "54be67c04834f13d7e255e1797d629a5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  python_dateutil = buildPythonPackage rec {
    name = "python-dateutil-1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/${name}.tar.gz";
      md5 = "0dcb1de5e5cad69490a3b6ab63f0cfa5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  python_gettext = buildPythonPackage rec {
    name = "python-gettext-1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-gettext/${name}.zip";
      md5 = "cd4201d440126d1296d1d2bc2b4795f3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  python_openid = buildPythonPackage rec {
    name = "python-openid-2.2.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-openid/${name}.zip";
      md5 = "f89d9d4f4dccfd33b5ce34eb4725f751";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  pytz = buildPythonPackage rec {
    name = "pytz-2012c";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytz/pytz-2012c.tar.gz";
      md5 = "1aa85f072e3d34ae310665967a0ce053";
    };

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  record = buildPythonPackage rec {
    name = "Record-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/R/Record/${name}.zip";
      md5 = "cfed6a89d4fb2c9cb995e9084c3071b7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  repoze_retry = buildPythonPackage rec {
    name = "repoze.retry-1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.retry/${name}.tar.gz";
      md5 = "55f9dbde5d7f939d93c352fef0f2ce8b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  repoze_tm2 = buildPythonPackage rec {
    name = "repoze.tm2-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.tm2/${name}.tar.gz";
      md5 = "c645a878874c8876c9c6b3467246afbc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  repoze_who = buildPythonPackage rec {
    name = "repoze.who-2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.who/${name}.tar.gz";
      md5 = "eab01991b6a2979678ce6015815262e2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  repoze_xmliter = buildPythonPackage rec {
    name = "repoze.xmliter-0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.xmliter/${name}.zip";
      md5 = "99da76bcbad6fbaced4a273bde29b10e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  restrictedpython = buildPythonPackage rec {
    name = "RestrictedPython-3.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/R/RestrictedPython/${name}.zip";
      md5 = "aa75a7dcc7fbc966357837cc66cacec6";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  roman = buildPythonPackage rec {
    name = "roman-1.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/roman/${name}.tar.gz";
      md5 = "4f8832ed4108174b159c2afb4bd1d1dd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  rwproperty = buildPythonPackage rec {
    name = "rwproperty-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/rwproperty/${name}.tar.gz";
      md5 = "050bdf066492b3cd82a3399f8efea6b1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  simplejson = buildPythonPackage rec {
    name = "simplejson-2.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/simplejson/${name}.tar.gz";
      md5 = "d7a7acf0bd7681bd116b5c981d2f7959";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  sphinx = buildPythonPackage rec {
    name = "Sphinx-1.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/Sphinx/${name}.tar.gz";
      md5 = "8f55a6d4f87fc6d528120c5d1f983e98";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  tempstorage = buildPythonPackage rec {
    name = "tempstorage-2.12.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tempstorage/${name}.zip";
      md5 = "7a2b76b39839e229249b1bb175604480";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  tl_eggdeps = buildPythonPackage rec {
    name = "tl.eggdeps-0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tl.eggdeps/${name}.tar.gz";
      md5 = "2472204a2abd0d8cd4d11ff0fbf36ae7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  transaction = buildPythonPackage rec {
    name = "transaction-1.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/transaction/${name}.tar.gz";
      md5 = "30b062baa34fe1521ad979fb088c8c55";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  unidecode = buildPythonPackage rec {
    name = "Unidecode-0.04.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/U/Unidecode/${name}2.tar.gz";
      md5 = "351dc98f4512bdd2e93f7a6c498730eb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  unittest2 = buildPythonPackage rec {
    name = "unittest2-0.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/u/unittest2/${name}.tar.gz";
      md5 = "a0af5cac92bbbfa0c3b0e99571390e0f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  webob = buildPythonPackage rec {
    name = "WebOb-1.0.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebOb/${name}.zip";
      md5 = "9809f9fb64fca8690a7da533fa29a272";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  wicked = buildPythonPackage rec {
    name = "wicked-1.1.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/w/wicked/${name}.zip";
      md5 = "f65611f11d547d7dc8e623bf87d3929d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  wsgi_intercept = buildPythonPackage rec {
    name = "wsgi-intercept-0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/w/wicked/wicked-1.1.10.zip";
      md5 = "f65611f11d547d7dc8e623bf87d3929d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_autoinclude = buildPythonPackage rec {
    name = "z3c.autoinclude-0.3.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.autoinclude/${name}.zip";
      md5 = "6a615ae18c12b459bceb3ae28e8e7709";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_batching = buildPythonPackage rec {
    name = "z3c.batching-1.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.batching/${name}.tar.gz";
      md5 = "d1dc834781d228127ca6d15301757863";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_blobfile = buildPythonPackage rec {
    name = "z3c.blobfile-0.1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.blobfile/${name}.zip";
      md5 = "2e806640aa2f3b51e4578f35c44f567a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_caching = buildPythonPackage rec {
    name = "z3c.caching-2.0a1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.caching/${name}.tar.gz";
      md5 = "17f250b5084c2324a7d15c6810ee628e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_checkversions = buildPythonPackage rec {
    name = "z3c.checkversions-0.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.checkversions/${name}.tar.gz";
      md5 = "907f3a28aac04ad98fb3c4c5879a1eaf";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_coverage = buildPythonPackage rec {
    name = "z3c.coverage-1.2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.coverage/${name}.tar.gz";
      md5 = "d7f323a6c89f848fab38209f2162294d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_form = buildPythonPackage rec {
    name = "z3c.form-2.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.form/${name}.tar.gz";
      md5 = "f029f83dd226f695f55049ed1ecee95e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_formwidget_query = buildPythonPackage rec {
    name = "z3c.formwidget.query-0.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.formwidget.query/${name}.zip";
      md5 = "d9f7960b1a5a81d8ba5241530f496522";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_objpath = buildPythonPackage rec {
    name = "z3c.objpath-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.objpath/${name}.tar.gz";
      md5 = "63641934441b255ebeeaeabc618f01ed";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_ptcompat = buildPythonPackage rec {
    name = "z3c.ptcompat-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.ptcompat/${name}.tar.gz";
      md5 = "bfe1ba6f9a38679705bd3eb5a5a2d7c4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_recipe_compattest = buildPythonPackage rec {
    name = "z3c.recipe.compattest-0.12.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.recipe.compattest/${name}.tar.gz";
      md5 = "ed5a1bde7ce384154721913846c736c7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_recipe_depgraph = buildPythonPackage rec {
    name = "z3c.recipe.depgraph-0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.recipe.depgraph/${name}.zip";
      md5 = "eb734419815146eb5b7080b5e17346dc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_recipe_sphinxdoc = buildPythonPackage rec {
    name = "z3c.recipe.sphinxdoc-0.0.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.recipe.sphinxdoc/${name}.tar.gz";
      md5 = "86e6965c919b43fa1de07588580f8790";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_relationfield = buildPythonPackage rec {
    name = "z3c.relationfield-0.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.relationfield/${name}.zip";
      md5 = "e34a6230cdfbd4a0bc1c90a77600e0e7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_template = buildPythonPackage rec {
    name = "z3c.template-1.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.template/${name}.tar.gz";
      md5 = "330e2dba8cd064d5790392afd9f460dd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  z3c_zcmlhook = buildPythonPackage rec {
    name = "z3c.zcmlhook-1.0b1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/z3c.zcmlhook/${name}.tar.gz";
      md5 = "7b6c80146f5930409eb0b355ddf3daeb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zc_lockfile = buildPythonPackage rec {
    name = "zc.lockfile-1.0.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.lockfile/${name}.tar.gz";
      md5 = "6cf83766ef9935c33e240b0904c7a45e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zc_recipe_egg = buildPythonPackage rec {
    name = "zc.recipe.egg-1.3.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.recipe.egg/${name}.tar.gz";
      md5 = "1cb6af73f527490dde461d3614a36475";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zc_recipe_testrunner = buildPythonPackage rec {
    name = "zc.recipe.testrunner-1.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.recipe.testrunner/${name}.tar.gz";
      md5 = "1be4a1518e5b94890634468118242850";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zc_relation = buildPythonPackage rec {
    name = "zc.relation-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.relation/${name}.tar.gz";
      md5 = "7e479095954fc6d8f648951434695837";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zc_resourcelibrary = buildPythonPackage rec {
    name = "zc.resourcelibrary-1.3.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.resourcelibrary/${name}.tar.gz";
      md5 = "bebe49f3e930f896a8ea75531bf3fae8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zc_sourcefactory = buildPythonPackage rec {
    name = "zc.sourcefactory-0.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.sourcefactory/${name}.tar.gz";
      md5 = "532dfd0a72489023268c19e3788b105d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zconfig = buildPythonPackage rec {
    name = "ZConfig-2.9.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZConfig/${name}.zip";
      md5 = "5c932690a70c8907efd240cdd76a7bc4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zdaemon = buildPythonPackage rec {
    name = "zdaemon-2.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zdaemon/${name}.tar.gz";
      md5 = "291a875f82e812110557eb6704af8afe";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zexceptions = buildPythonPackage rec {
    name = "zExceptions-2.13.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zExceptions/${name}.zip";
      md5 = "4c679696c959040d8e656ef85ae40136";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zlog = buildPythonPackage rec {
    name = "zLOG-2.11.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zLOG/${name}.tar.gz";
      md5 = "68073679aaa79ac5a7b6a5c025467147";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zodb3 = buildPythonPackage rec {
    name = "ZODB3-3.10.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZODB3/${name}.tar.gz";
      md5 = "6f180c6897a1820948fee2a6290503cd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zodbcode = buildPythonPackage rec {
    name = "zodbcode-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zodbcode/${name}.tar.gz";
      md5 = "9b128f89aa2a2117fae4f74757eefeff";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope2 = buildPythonPackage rec {
    name = "Zope2-2.13.19";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/Zope2/${name}.zip";
      md5 = "26fee311aace7c12e406543ea91eb42a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_annotation = buildPythonPackage rec {
    name = "zope.annotation-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.annotation/${name}.tar.gz";
      md5 = "4238153279d3f30ab5613438c8e76380";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_apidoc = buildPythonPackage rec {
    name = "zope.app.apidoc-3.7.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.apidoc/${name}.zip";
      md5 = "91e969b2d1089bb0a6a303990d269f0a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_applicationcontrol = buildPythonPackage rec {
    name = "zope.app.applicationcontrol-3.5.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.applicationcontrol/${name}.tar.gz";
      md5 = "f785c13698192c83024fda75f1f3d822";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_appsetup = buildPythonPackage rec {
    name = "zope.app.appsetup-3.14.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.appsetup/${name}.tar.gz";
      md5 = "2c3da1f514e6793e2bf612cb06ad9076";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_authentication = buildPythonPackage rec {
    name = "zope.app.authentication-3.8.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.authentication/${name}.tar.gz";
      md5 = "f8eb74fbdeebfd32c5e15c0f03aa3623";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_basicskin = buildPythonPackage rec {
    name = "zope.app.basicskin-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.basicskin/${name}.tar.gz";
      md5 = "75915a315f336a5b614db67df1093eb3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_broken = buildPythonPackage rec {
    name = "zope.app.broken-3.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.broken/${name}.tar.gz";
      md5 = "e6a7efdd1ea1facfd8c5ba4b25d395cb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_cache = buildPythonPackage rec {
    name = "zope.app.cache-3.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.cache/${name}.zip";
      md5 = "8dd74574e869ce236ced0de7e349bb5c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_catalog = buildPythonPackage rec {
    name = "zope.app.catalog-3.8.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.catalog/${name}.tar.gz";
      md5 = "1ce21dee4e8256cfe254f8ee24c6ecef";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_component = buildPythonPackage rec {
    name = "zope.app.component-3.9.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.component/${name}.tar.gz";
      md5 = "bc2dce245d2afe462529c350956711e0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_container = buildPythonPackage rec {
    name = "zope.app.container-3.9.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.container/${name}.tar.gz";
      md5 = "1e286c59f0166e517d67ddd723641c84";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_content = buildPythonPackage rec {
    name = "zope.app.content-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.content/${name}.tar.gz";
      md5 = "0ac6a6fcb5dd6f845759f998d8e8cbb3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_dav = buildPythonPackage rec {
    name = "zope.app.dav-3.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.dav/${name}.tar.gz";
      md5 = "19ec8dc5f7ad21468dea1c46e86d95dd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_debug = buildPythonPackage rec {
    name = "zope.app.debug-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.debug/${name}.tar.gz";
      md5 = "1a9d349b14d91137b57da52a2b9d185f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_debugskin = buildPythonPackage rec {
    name = "zope.app.debugskin-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.debugskin/${name}.tar.gz";
      md5 = "bd95d2848aa3108e53717d13b3c0924d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_dependable = buildPythonPackage rec {
    name = "zope.app.dependable-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.dependable/${name}.zip";
      md5 = "5f180620a880e6ec754e3a34bd110891";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_error = buildPythonPackage rec {
    name = "zope.app.error-3.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.error/${name}.tar.gz";
      md5 = "bab82dd06233e9b5e34e9709e8993ace";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_exception = buildPythonPackage rec {
    name = "zope.app.exception-3.6.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.exception/${name}.tar.gz";
      md5 = "af161d3e7c17db7f56f7816a6f2d980c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_file = buildPythonPackage rec {
    name = "zope.app.file-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.file/${name}.tar.gz";
      md5 = "fff140c36a2872c85b55433835ac3b98";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_folder = buildPythonPackage rec {
    name = "zope.app.folder-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.folder/${name}.tar.gz";
      md5 = "5ba3a2a7ec527a7eb0cc3c2eb7bb75e9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_form = buildPythonPackage rec {
    name = "zope.app.form-4.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.form/${name}.tar.gz";
      md5 = "3d2b164d9d37a71490a024aaeb412e91";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_ftp = buildPythonPackage rec {
    name = "zope.app.ftp-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.ftp/${name}.tar.gz";
      md5 = "b0769f90023156a86cb3f46040e6b5b0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_generations = buildPythonPackage rec {
    name = "zope.app.generations-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.generations/${name}.tar.gz";
      md5 = "ca74e0f4a01ad8767e1bba6332c39aa2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_http = buildPythonPackage rec {
    name = "zope.app.http-3.9.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.http/${name}.tar.gz";
      md5 = "26f73a3affecefc3aff960cd8b088681";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_i18n = buildPythonPackage rec {
    name = "zope.app.i18n-3.6.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.i18n/${name}.tar.gz";
      md5 = "c8573307ba08926214b7944a05e43632";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_interface = buildPythonPackage rec {
    name = "zope.app.interface-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.interface/${name}.tar.gz";
      md5 = "b15522275a435c609bd44f2f019bd13c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_interpreter = buildPythonPackage rec {
    name = "zope.app.interpreter-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.interpreter/${name}.tar.gz";
      md5 = "fb8a2aa57dcfa3af2f30801dfafc78c4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_intid = buildPythonPackage rec {
    name = "zope.app.intid-3.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.intid/${name}.tar.gz";
      md5 = "0d2c1daf5d1d6fd09351b652042a2dac";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_keyreference = buildPythonPackage rec {
    name = "zope.app.keyreference-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.keyreference/${name}.tar.gz";
      md5 = "78539e472016a8ca57b34b6ea0ab7d9d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_locales = buildPythonPackage rec {
    name = "zope.app.locales-3.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.locales/${name}.tar.gz";
      md5 = "bd2b4c6040e768f33004b1210d3207fa";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_localpermission = buildPythonPackage rec {
    name = "zope.app.localpermission-3.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.localpermission/${name}.tar.gz";
      md5 = "121509781b19ce55ebe890fa408702fc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_locking = buildPythonPackage rec {
    name = "zope.app.locking-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.locking/${name}.tar.gz";
      md5 = "4edce1ba26f6c56b0eb79f703d8a80fe";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_onlinehelp = buildPythonPackage rec {
    name = "zope.app.onlinehelp-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.onlinehelp/${name}.tar.gz";
      md5 = "67d0be66965e34b24ef18c269da62e4c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_pagetemplate = buildPythonPackage rec {
    name = "zope.app.pagetemplate-3.11.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.pagetemplate/${name}.tar.gz";
      md5 = "2d304729c0d6a9ab67dd5ea852f19476";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_preference = buildPythonPackage rec {
    name = "zope.app.preference-3.8.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.preference/${name}.tar.gz";
      md5 = "ab6906261854c61ff9f0a13c7612d3e8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_preview = buildPythonPackage rec {
    name = "zope.app.preview-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.preview/${name}.tar.gz";
      md5 = "e698c10b043fb944150a825af9af536e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_principalannotation = buildPythonPackage rec {
    name = "zope.app.principalannotation-3.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.principalannotation/${name}.tar.gz";
      md5 = "29c6bf8e817330b0d29de253686a68f2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_publication = buildPythonPackage rec {
    name = "zope.app.publication-3.12.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.publication/${name}.zip";
      md5 = "d8c521287f52fb9f40fa9b8c2acb4675";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_publisher = buildPythonPackage rec {
    name = "zope.app.publisher-3.10.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.publisher/${name}.zip";
      md5 = "66e9110e2967d8d204a65a98e2227404";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_renderer = buildPythonPackage rec {
    name = "zope.app.renderer-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.renderer/${name}.tar.gz";
      md5 = "1cc605baf5dab7db50b0a0fd218566f3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_rotterdam = buildPythonPackage rec {
    name = "zope.app.rotterdam-3.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.rotterdam/${name}.tar.gz";
      md5 = "4cb3c53844bc7481f9b7d60f3c5e3a85";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_schema = buildPythonPackage rec {
    name = "zope.app.schema-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.schema/${name}.tar.gz";
      md5 = "92b7c3f4512f3433acc931ecb6ffc936";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_security = buildPythonPackage rec {
    name = "zope.app.security-3.7.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.security/${name}.tar.gz";
      md5 = "c7cec00f6d8379b93180faf6ffaa89ea";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_securitypolicy = buildPythonPackage rec {
    name = "zope.app.securitypolicy-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.securitypolicy/${name}.tar.gz";
      md5 = "e3c6ef1db3228dbbb60a452c1a2a8f27";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_server = buildPythonPackage rec {
    name = "zope.app.server-3.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.server/${name}.tar.gz";
      md5 = "d3a75eaf2a3f4759352dd3243dfb1d50";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_session = buildPythonPackage rec {
    name = "zope.app.session-3.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.session/${name}.tar.gz";
      md5 = "93467bf6854d714b53e71f36a9d770f3";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_skins = buildPythonPackage rec {
    name = "zope.app.skins-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.skins/${name}.tar.gz";
      md5 = "a0bc210720ee50e40adb93e9c685e884";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_testing = buildPythonPackage rec {
    name = "zope.app.testing-3.7.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.testing/${name}.tar.gz";
      md5 = "6fd3eb11e24973a3dbdf5f1ab655c0d4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_tree = buildPythonPackage rec {
    name = "zope.app.tree-3.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.tree/${name}.tar.gz";
      md5 = "fbde3403c682bc7cf7b73d43cd2eed3a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_twisted = buildPythonPackage rec {
    name = "zope.app.twisted-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.twisted/${name}.tar.gz";
      md5 = "9e98868b8be8a0c4f720036366364a67";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_undo = buildPythonPackage rec {
    name = "zope.app.undo-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.undo/${name}.tar.gz";
      md5 = "7a40060aa0451a635a31d6e12d17a82e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_wsgi = buildPythonPackage rec {
    name = "zope.app.wsgi-3.9.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.wsgi/${name}.tar.gz";
      md5 = "9c766908b720d777e02e0b0a9ac8a8a1";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_zcmlfiles = buildPythonPackage rec {
    name = "zope.app.zcmlfiles-3.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.zcmlfiles/${name}.tar.gz";
      md5 = "0e8991d2bed71ee6b98a2c48d21e1126";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_zopeappgenerations = buildPythonPackage rec {
    name = "zope.app.zopeappgenerations-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.zopeappgenerations/${name}.tar.gz";
      md5 = "4c8a0bc409677f8b17dc57737d41f919";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_app_zptpage = buildPythonPackage rec {
    name = "zope.app.zptpage-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.app.zptpage/${name}.tar.gz";
      md5 = "aed8ec49e10911bd1e9d2c9d467fd098";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_applicationcontrol = buildPythonPackage rec {
    name = "zope.applicationcontrol-3.5.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.applicationcontrol/${name}.tar.gz";
      md5 = "5e4bb54afe55185e15bd9d1ba3750857";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_authentication = buildPythonPackage rec {
    name = "zope.authentication-3.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.authentication/${name}.zip";
      md5 = "7d6bb340610518f2fc71213cfeccda68";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_broken = buildPythonPackage rec {
    name = "zope.broken-3.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.broken/${name}.zip";
      md5 = "eff24d7918099a3e899ee63a9c31bee6";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_browser = buildPythonPackage rec {
    name = "zope.browser-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.browser/${name}.zip";
      md5 = "4ff0ddbf64c45bfcc3189e35f4214ded";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_browsermenu = buildPythonPackage rec {
    name = "zope.browsermenu-3.9.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.browsermenu/${name}.zip";
      md5 = "a47c7b1e786661c912a1150bf8d1f83f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_browserpage = buildPythonPackage rec {
    name = "zope.browserpage-3.12.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.browserpage/${name}.tar.gz";
      md5 = "a543ef3cb1b42f7233b3fca23dc9ea60";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_browserresource = buildPythonPackage rec {
    name = "zope.browserresource-3.10.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.browserresource/${name}.zip";
      md5 = "dbfde30e82dbfa1a74c5da0cb5a4772d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_cachedescriptors = buildPythonPackage rec {
    name = "zope.cachedescriptors-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.cachedescriptors/${name}.zip";
      md5 = "263459a95238fd61d17e815d97ca49ce";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_catalog = buildPythonPackage rec {
    name = "zope.catalog-3.8.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.catalog/${name}.tar.gz";
      md5 = "f9baff3997e337f0a23ac158258c8842";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_component = buildPythonPackage rec {
    name = "zope.component-3.9.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.component/${name}.tar.gz";
      md5 = "22780b445b1b479701c05978055d1c82";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_componentvocabulary = buildPythonPackage rec {
    name = "zope.componentvocabulary-1.0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.componentvocabulary/${name}.tar.gz";
      md5 = "1c8fa82ca1ab1f4b0bd2455a31fde22b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_configuration = buildPythonPackage rec {
    name = "zope.configuration-3.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.configuration/${name}.zip";
      md5 = "5b0271908ef26c05059eda76928896ea";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_container = buildPythonPackage rec {
    name = "zope.container-3.11.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.container/${name}.tar.gz";
      md5 = "fc66d85a17b8ffb701091c9328983dcc";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_contentprovider = buildPythonPackage rec {
    name = "zope.contentprovider-3.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.contentprovider/${name}.tar.gz";
      md5 = "1bb2132551175c0123f17939a793f812";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_contenttype = buildPythonPackage rec {
    name = "zope.contenttype-3.5.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.contenttype/${name}.zip";
      md5 = "c6ac80e6887de4108a383f349fbdf332";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_copy = buildPythonPackage rec {
    name = "zope.copy-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.copy/${name}.tar.gz";
      md5 = "a9836a5d36cd548be45210eb00407337";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_copypastemove = buildPythonPackage rec {
    name = "zope.copypastemove-3.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.copypastemove/${name}.tar.gz";
      md5 = "f335940686d15cfc5520c42f2494a924";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_datetime = buildPythonPackage rec {
    name = "zope.datetime-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.datetime/${name}.tar.gz";
      md5 = "4dde22d34f41a0a4f0c5a345e6d11ee9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_deferredimport = buildPythonPackage rec {
    name = "zope.deferredimport-3.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.deferredimport/${name}.tar.gz";
      md5 = "68fce3bf4f011d4a840902fd763884ee";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_deprecation = buildPythonPackage rec {
    name = "zope.deprecation-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.deprecation/${name}.tar.gz";
      md5 = "8a47b0f8e1fa4e833007e5b8351bb1d4";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_documenttemplate = buildPythonPackage rec {
    name = "zope.documenttemplate-3.4.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.documenttemplate/${name}.tar.gz";
      md5 = "d5c302534ee0913c39bdc227e1592cb7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_dottedname = buildPythonPackage rec {
    name = "zope.dottedname-3.4.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.dottedname/${name}.tar.gz";
      md5 = "62d639f75b31d2d864fe5982cb23959c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_dublincore = buildPythonPackage rec {
    name = "zope.dublincore-3.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.dublincore/${name}.tar.gz";
      md5 = "2e34e42e454d896feb101ac74af62ded";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_error = buildPythonPackage rec {
    name = "zope.error-3.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.error/${name}.tar.gz";
      md5 = "281445a906458ff5f18f56923699a127";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_event = buildPythonPackage rec {
    name = "zope.event-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.event/${name}.tar.gz";
      md5 = "6e8af2a16157a74885d4f0d88137cefb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_exceptions = buildPythonPackage rec {
    name = "zope.exceptions-3.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.exceptions/${name}.tar.gz";
      md5 = "d7234d99d728abe3d9275346e8d24fd9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_file = buildPythonPackage rec {
    name = "zope.file-0.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.file/${name}.tar.gz";
      md5 = "5df3b63c678f4b445be345f1dff1bc9b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_filerepresentation = buildPythonPackage rec {
    name = "zope.filerepresentation-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.filerepresentation/${name}.tar.gz";
      md5 = "4a7a434094f4bfa99a7f22e75966c359";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_formlib = buildPythonPackage rec {
    name = "zope.formlib-4.0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.formlib/${name}.zip";
      md5 = "eed9c94382d11a4dececd0a48ac1d3f2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_globalrequest = buildPythonPackage rec {
    name = "zope.globalrequest-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.globalrequest/${name}.zip";
      md5 = "ae6ff02db5ba89c1fb96ed7a73ca1cfa";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_hookable = buildPythonPackage rec {
    name = "zope.hookable-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.hookable/${name}.tar.gz";
      md5 = "fe6713aef5b6c0f4963fb984bf326da0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_html = buildPythonPackage rec {
    name = "zope.html-2.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.html/${name}.tar.gz";
      md5 = "868cb987e400b9a290355a1207d47143";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_i18n = buildPythonPackage rec {
    name = "zope.i18n-3.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.i18n/${name}.tar.gz";
      md5 = "a6fe9d9ad53dd7e94e87cd58fb67d3b7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_i18nmessageid = buildPythonPackage rec {
    name = "zope.i18nmessageid-3.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.i18nmessageid/${name}.tar.gz";
      md5 = "cb84bf61c2b7353e3b7578057fbaa264";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_index = buildPythonPackage rec {
    name = "zope.index-3.6.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.index/${name}.tar.gz";
      md5 = "65c34f446f54ffd711e34ede9eb89dad";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_interface = buildPythonPackage rec {
    name = "zope.interface-3.6.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.interface/${name}.zip";
      md5 = "9df962180fbbb54eb1875cff9fe436e5";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_intid = buildPythonPackage rec {
    name = "zope.intid-3.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.intid/${name}.zip";
      md5 = "241f2fe62fb60f6319d9902b12bc333d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_keyreference = buildPythonPackage rec {
    name = "zope.keyreference-3.6.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.keyreference/${name}.tar.gz";
      md5 = "3774c90f236f880547f4c042ee0997e9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_kgs = buildPythonPackage rec {
    name = "zope.kgs-1.2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.kgs/${name}.tar.gz";
      md5 = "15ed01a270bddcf253b1c08479549692";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_lifecycleevent = buildPythonPackage rec {
    name = "zope.lifecycleevent-3.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.lifecycleevent/${name}.tar.gz";
      md5 = "3ba978f3ba7c0805c81c2c79ea3edb33";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_location = buildPythonPackage rec {
    name = "zope.location-3.9.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.location/${name}.tar.gz";
      md5 = "1684a8f986099d15296f670c58e713d8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_login = buildPythonPackage rec {
    name = "zope.login-1.0.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.login/${name}.zip";
      md5 = "4eceb766329125a80aee1b4b4809869a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_mimetype = buildPythonPackage rec {
    name = "zope.mimetype-1.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.mimetype/${name}.tar.gz";
      md5 = "c865758c896707287f86ba603f06a84b";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_minmax = buildPythonPackage rec {
    name = "zope.minmax-1.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.minmax/${name}.tar.gz";
      md5 = "0c3fbac9623f402ed758dace80080d55";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_mkzeoinstance = buildPythonPackage rec {
    name = "zope.mkzeoinstance-3.9.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.mkzeoinstance/${name}.tar.gz";
      md5 = "2c2dcf7cc7de58f7d009ca3294f54377";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_modulealias = buildPythonPackage rec {
    name = "zope.modulealias-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.modulealias/${name}.tar.gz";
      md5 = "77f4603524b578a5c6b4b4fdde58a484";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_pagetemplate = buildPythonPackage rec {
    name = "zope.pagetemplate-3.6.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.pagetemplate/${name}.zip";
      md5 = "834a4bf702c05fba1e669677b4dc871f";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_password = buildPythonPackage rec {
    name = "zope.password-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.password/${name}.tar.gz";
      md5 = "230f93a79020c8a3dc01d79832546e3c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_pluggableauth = buildPythonPackage rec {
    name = "zope.pluggableauth-1.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.pluggableauth/${name}.tar.gz";
      md5 = "85d16cb2e5b41bf2a438828857719566";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_preference = buildPythonPackage rec {
    name = "zope.preference-3.8.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.preference/${name}.tar.gz";
      md5 = "bb8b1c9f65387a51be429407528cc453";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_principalannotation = buildPythonPackage rec {
    name = "zope.principalannotation-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.principalannotation/${name}.tar.gz";
      md5 = "652685ca13cefaad78dbc5c6507fc9ab";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_principalregistry = buildPythonPackage rec {
    name = "zope.principalregistry-3.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.principalregistry/${name}.tar.gz";
      md5 = "9b90adc7915d9bbed4237db432fc70c2";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_processlifetime = buildPythonPackage rec {
    name = "zope.processlifetime-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.processlifetime/${name}.tar.gz";
      md5 = "69604bfd668a01ebebdd616a8f26ccfe";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_proxy = buildPythonPackage rec {
    name = "zope.proxy-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.proxy/${name}.zip";
      md5 = "a400b0a26624b17fa889dbcaa989d440";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_ptresource = buildPythonPackage rec {
    name = "zope.ptresource-3.9.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.ptresource/${name}.tar.gz";
      md5 = "f4645e51c15289d3fdfb4139039e18e9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_publisher = buildPythonPackage rec {
    name = "zope.publisher-3.12.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.publisher/${name}.tar.gz";
      md5 = "495131970cc7cb14de8e517fb3857ade";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_ramcache = buildPythonPackage rec {
    name = "zope.ramcache-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.ramcache/${name}.zip";
      md5 = "87289e15f0e51f50704adda1557c02a7";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_rdb = buildPythonPackage rec {
    name = "zope.rdb-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.rdb/${name}.tar.gz";
      md5 = "2068b469c07c9c0b41392cd9839e3728";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_schema = buildPythonPackage rec {
    name = "zope.schema-4.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.schema/${name}.zip";
      md5 = "bfa0460b68df0dbbf7a5dc793b0eecc6";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_security = buildPythonPackage rec {
    name = "zope.security-3.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.security/${name}.tar.gz";
      md5 = "072ab8d11adc083eace11262da08630c";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_securitypolicy = buildPythonPackage rec {
    name = "zope.securitypolicy-3.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.securitypolicy/${name}.tar.gz";
      md5 = "fe9ba029384c0640b2ba175ba1805cd8";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_sendmail = buildPythonPackage rec {
    name = "zope.sendmail-3.7.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.sendmail/${name}.tar.gz";
      md5 = "8a513ecf2b41cad849f6607bf16d6818";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_sequencesort = buildPythonPackage rec {
    name = "zope.sequencesort-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.sequencesort/${name}.tar.gz";
      md5 = "cfc35fc426a47f5c0ee43c416224b864";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_server = buildPythonPackage rec {
    name = "zope.server-3.6.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.server/${name}.tar.gz";
      md5 = "2a758720fd6d9bdfb1cea8d644c27923";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_session = buildPythonPackage rec {
    name = "zope.session-3.9.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.session/${name}.tar.gz";
      md5 = "2934e9f2daa01555e9a7a1f9945c3493";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_site = buildPythonPackage rec {
    name = "zope.site-3.9.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.site/${name}.tar.gz";
      md5 = "36a0b8dfbd713ed452ce6973ab0a3ddb";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_size = buildPythonPackage rec {
    name = "zope.size-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.size/${name}.tar.gz";
      md5 = "55d9084dfd9dcbdb5ad2191ceb5ed03d";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_structuredtext = buildPythonPackage rec {
    name = "zope.structuredtext-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.structuredtext/${name}.tar.gz";
      md5 = "eabbfb983485d0879322bc878d2478a0";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_tal = buildPythonPackage rec {
    name = "zope.tal-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.tal/${name}.zip";
      md5 = "13869f292ba36b294736b7330b1396fd";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_tales = buildPythonPackage rec {
    name = "zope.tales-3.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.tales/${name}.tar.gz";
      md5 = "1c5060bd766a0a18632b7879fc9e4e1e";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_testbrowser = buildPythonPackage rec {
    name = "zope.testbrowser-3.11.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testbrowser/${name}.tar.gz";
      md5 = "64abbee892121e7f1a91aed12cfc155a";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_testing = buildPythonPackage rec {
    name = "zope.testing-3.9.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testing/${name}.tar.gz";
      md5 = "8999f3d143d416dc3c8b2a5bd6f33e28";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_thread = buildPythonPackage rec {
    name = "zope.thread-3.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.thread/${name}.tar.gz";
      md5 = "3567037865b746c933d4af86e5aefa35";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_traversing = buildPythonPackage rec {
    name = "zope.traversing-3.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.traversing/${name}.zip";
      md5 = "eaad8fc7bbef126f9f8616b074ec00aa";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_viewlet = buildPythonPackage rec {
    name = "zope.viewlet-3.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.viewlet/${name}.tar.gz";
      md5 = "367e03096df57e2f9b74fff43f7901f9";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zope_xmlpickle = buildPythonPackage rec {
    name = "zope.xmlpickle-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.xmlpickle/${name}.tar.gz";
      md5 = "b579f35546b095aec2c890d3f8a46911";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  zopeundo = buildPythonPackage rec {
    name = "ZopeUndo-2.12.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZopeUndo/${name}.zip";
      md5 = "2b8da09d1b98d5558f62e12f6e52c401";
    };

    # ignore dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    buildInputs = [ pkgs.unzip ];

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };


  eggtestinfo = buildPythonPackage rec {
    name = "eggtestinfo-0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/eggtestinfo/${name}.tar.gz";
      md5 = "6f0507aee05f00c640c0d64b5073f840";
    };

    # circular dependencies
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.chaoflow
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.goibhniu
     ];
    };
  };

}; in plone42Packages

# Not Found: ['nt-svcutils', 'PIL', 'wsgi-intercept']
# Version Error: ['collective.z3cform.datagridfield-demo']
