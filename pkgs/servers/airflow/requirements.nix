# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -V 2.7 -E libmysql -E openssl -E cyrus_sasl -E postgresql -E libffi -E libxml2 -E libxslt -r requirements.txt
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python27Full;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  commonBuildInputs = with pkgs; [ libmysql openssl cyrus_sasl postgresql libffi libxml2 libxslt ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python27Full-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable}               python2
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs //                                            { meta = drv.meta; });
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "Babel" = python.mkDerivation {
      name = "Babel-2.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4/Babel-2.6.0.tar.gz"; sha256 = "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pytz"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://babel.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "Internationalization utilities";
      };
    };



    "Flask" = python.mkDerivation {
      name = "Flask-0.11.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/55/8a/78e165d30f0c8bb5d57c429a30ee5749825ed461ad6c959688872643ffb3/Flask-0.11.1.tar.gz"; sha256 = "b4713f2bfb9ebc2966b8a49903ae0d3984781d5c878591cf2f7b484d28756b0e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
      self."Werkzeug"
      self."click"
      self."itsdangerous"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/pallets/flask/";
        license = licenses.bsdOriginal;
        description = "A microframework based on Werkzeug, Jinja2 and good intentions";
      };
    };



    "Flask-Admin" = python.mkDerivation {
      name = "Flask-Admin-1.4.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/39/65/eb6238c40cd9ec20279969ef9ee7ac412fc7c9a6681965bcd58a63eeac2b/Flask-Admin-1.4.1.tar.gz"; sha256 = "88618750e08ceee1ab232a5a9ebcef31275db5db1c0b56db29e014c24c7067a4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."WTForms"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/flask-admin/flask-admin/";
        license = licenses.bsdOriginal;
        description = "Simple and extensible admin interface framework for Flask";
      };
    };



    "Flask-Bcrypt" = python.mkDerivation {
      name = "Flask-Bcrypt-0.7.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1d/c0/6d4c04d007d72b355de24e7a223978d1a95732245f9e9becbf45d3024bf8/Flask-Bcrypt-0.7.1.tar.gz"; sha256 = "d71c8585b2ee1c62024392ebdbc447438564e2c8c02b4e57b56a4cafd8d13c5f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."bcrypt"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/maxcountryman/flask-bcrypt";
        license = licenses.bsdOriginal;
        description = "Brcrypt hashing for Flask.";
      };
    };



    "Flask-Cache" = python.mkDerivation {
      name = "Flask-Cache-0.13.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/91/c4/f71095437bd4b691c63f240e72a20c57e2c216085cbc271f79665885d3da/Flask-Cache-0.13.1.tar.gz"; sha256 = "90126ca9bc063854ef8ee276e95d38b2b4ec8e45fd77d5751d37971ee27c7ef4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/thadeusb/flask-cache";
        license = licenses.bsdOriginal;
        description = "Adds cache support to your Flask application";
      };
    };



    "Flask-Login" = python.mkDerivation {
      name = "Flask-Login-0.2.11";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/42/3c/ead3f50b8a39b6dd3499ae6f0f5b13b955130c92a7479a287e2e07921faf/Flask-Login-0.2.11.tar.gz"; sha256 = "83d5f10e5c4f214feed6cc41c212db63a58a15ac32e56df81591bfa0a5cee3e5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/maxcountryman/flask-login";
        license = licenses.mit;
        description = "User session management for Flask";
      };
    };



    "Flask-WTF" = python.mkDerivation {
      name = "Flask-WTF-0.14";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/df/d9/b5f598d227e101979ccc6a029c19ff9e103491f6b28ac25513c793ae3c83/Flask-WTF-0.14.tar.gz"; sha256 = "a938bfabc450b61e2d76f8b32288b65d0cd43ce33c2de496e1b28152c5d141cf"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."WTForms"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lepture/flask-wtf";
        license = licenses.bsdOriginal;
        description = "Simple integration of Flask and WTForms.";
      };
    };



    "GitPython" = python.mkDerivation {
      name = "GitPython-2.1.11";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4d/e8/98e06d3bc954e3c5b34e2a579ddf26255e762d21eb24fede458eff654c51/GitPython-2.1.11.tar.gz"; sha256 = "8237dc5bfd6f1366abeee5624111b9d6879393d84745a507de0fda86043b65a8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."gitdb2"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gitpython-developers/GitPython";
        license = licenses.bsdOriginal;
        description = "Python Git Library";
      };
    };



    "JPype1" = python.mkDerivation {
      name = "JPype1-0.6.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c4/4b/60a3e63d51714d4d7ef1b1efdf84315d118a0a80a5b085bb52a7e2428cdc/JPype1-0.6.3.tar.gz"; sha256 = "6841523631874a731e1f94e1b1f130686ad3772030eaa3b6946256eeb1d10dd1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."numpy"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/originell/jpype/";
        license = "License :: OSI Approved :: Apache Software License";
        description = "A Python to Java bridge.";
      };
    };



    "JayDeBeApi" = python.mkDerivation {
      name = "JayDeBeApi-1.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/26/d4/128621acee9c75cb6724eb678b9f9de98a52945d46a068e2c9ede0d10bbe/JayDeBeApi-1.1.1.tar.gz"; sha256 = "ba2dfa92c55e39476cea5a4b1a1750d94c8b3d166ed3c7f99601f19f744f2828"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."JPype1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/baztian/jaydebeapi";
        license = licenses.lgpl2;
        description = "Use JDBC database drivers from Python 2/3 or Jython with a DB-API.";
      };
    };



    "Jinja2" = python.mkDerivation {
      name = "Jinja2-2.8.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"; sha256 = "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Babel"
      self."MarkupSafe"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://jinja.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A small but fast and easy to use stand-alone template engine written in pure python.";
      };
    };



    "Mako" = python.mkDerivation {
      name = "Mako-1.0.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"; sha256 = "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."MarkupSafe"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.makotemplates.org/";
        license = licenses.mit;
        description = "A super-fast templating language that borrows the  best ideas from the existing templating languages.";
      };
    };



    "Markdown" = python.mkDerivation {
      name = "Markdown-2.6.11";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"; sha256 = "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://Python-Markdown.github.io/";
        license = licenses.bsdOriginal;
        description = "Python implementation of Markdown.";
      };
    };



    "MarkupSafe" = python.mkDerivation {
      name = "MarkupSafe-1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"; sha256 = "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/pallets/markupsafe";
        license = licenses.bsdOriginal;
        description = "Implements a XML/HTML/XHTML Markup safe string for Python";
      };
    };



    "PyHive" = python.mkDerivation {
      name = "PyHive-0.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/52/f5/2a582d7e35b0f3148375f49afadafb25dc2da735876a8b53b6862f0966f3/PyHive-0.6.0.tar.gz"; sha256 = "f754edd5089d742d2080978e773b18c67dc75f9e25cd416b6564516bf20c4385"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."SQLAlchemy"
      self."future"
      self."python-dateutil"
      self."requests"
      self."sasl"
      self."thrift"
      self."thrift-sasl"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/dropbox/PyHive";
        license = licenses.asl20;
        description = "Python interface to Hive";
      };
    };



    "PyJWT" = python.mkDerivation {
      name = "PyJWT-1.6.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/00/5e/b358c9bb24421e6155799d995b4aa3aa3307ffc7ecae4ad9d29fd7e07a73/PyJWT-1.6.4.tar.gz"; sha256 = "4ee413b357d53fd3fb44704577afac88e72e878716116270d722723d65b42176"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cryptography"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/jpadilla/pyjwt";
        license = licenses.mit;
        description = "JSON Web Token implementation in Python";
      };
    };



    "PyNaCl" = python.mkDerivation {
      name = "PyNaCl-1.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"; sha256 = "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
      self."cffi"
      self."six"
      self."sphinx-rtd-theme"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyca/pynacl/";
        license = licenses.asl20;
        description = "Python binding to the Networking and Cryptography (NaCl) library";
      };
    };



    "PySmbClient" = python.mkDerivation {
      name = "PySmbClient-0.1.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9f/81/1d3e94c27fd7ce8ed46ccf7260d321832b9778d283f43bdee29ea7527b0e/PySmbClient-0.1.5.tar.gz"; sha256 = "dc528959ffe3fae5cdd2053c0d68b6dfca706d8f4ea78b9b3e741daedc87aed4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/nosklo/pysmbclient";
        license = licenses.gpl1;
        description = "A convenient smbclient wrapper";
      };
    };



    "PyVCF" = python.mkDerivation {
      name = "PyVCF-0.6.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ca/d1/f1d394b0c2865d4c5d96856ffaa223b6013b3c1cbc74e0c2f2f4b34ea11f/PyVCF-0.6.8.linux-x86_64.tar.gz"; sha256 = "1b3c833dcf4cca830e8255e3ac0573d2e69f588f71f7a5efb2a92b45d7b70021"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jamescasbon/PyVCF";
        license = licenses.bsdOriginal;
        description = "Variant Call Format (VCF) parser for Python";
      };
    };



    "PyYAML" = python.mkDerivation {
      name = "PyYAML-3.13";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"; sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pyyaml.org/wiki/PyYAML";
        license = licenses.mit;
        description = "YAML parser and emitter for Python";
      };
    };



    "Pygments" = python.mkDerivation {
      name = "Pygments-2.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"; sha256 = "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };



    "SQLAlchemy" = python.mkDerivation {
      name = "SQLAlchemy-1.2.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8a/c2/29491103fd971f3988e90ee3a77bb58bad2ae2acd6e8ea30a6d1432c33a3/SQLAlchemy-1.2.10.tar.gz"; sha256 = "72325e67fb85f6e9ad304c603d83626d1df684fdf0c7ab1f0352e71feeab69d8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."mysqlclient"
      self."psycopg2"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.sqlalchemy.org";
        license = licenses.mit;
        description = "Database Abstraction Library";
      };
    };



    "Sphinx" = python.mkDerivation {
      name = "Sphinx-1.7.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/41/32/915efa0e95ef7c79458175b09d9ea9ffc34f4d6791ff84c9b113f3439178/Sphinx-1.7.5.tar.gz"; sha256 = "d45480a229edf70d84ca9fae3784162b1bc75ee47e480ffe04a4b7f21a95d76d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Babel"
      self."Jinja2"
      self."Pygments"
      self."SQLAlchemy"
      self."alabaster"
      self."colorama"
      self."docutils"
      self."enum34"
      self."html5lib"
      self."imagesize"
      self."mock"
      self."packaging"
      self."requests"
      self."six"
      self."snowballstemmer"
      self."sphinxcontrib-websupport"
      self."typing"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://sphinx-doc.org/";
        license = licenses.bsdOriginal;
        description = "Python documentation generator";
      };
    };



    "Sphinx-PyPI-upload" = python.mkDerivation {
      name = "Sphinx-PyPI-upload-0.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3e/68/723a5656d0fa705c1eae4c546ded85882fb4b3241b079aeab66e92513416/Sphinx-PyPI-upload-0.2.1.tar.gz"; sha256 = "5f919a47ce7a7e6028dba809de81ae1297ac192347cf6fc54efca919d4865159"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/jezdez/sphinx-pypi-upload/";
        license = licenses.bsdOriginal;
        description = "setuptools command for uploading Sphinx documentation to PyPI";
      };
    };



    "Unidecode" = python.mkDerivation {
      name = "Unidecode-1.0.22";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"; sha256 = "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = licenses.gpl2Plus;
        description = "ASCII transliterations of Unicode text";
      };
    };



    "WTForms" = python.mkDerivation {
      name = "WTForms-2.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cd/1d/7221354ebfc32b868740d02e44225c2ce00769b0d3dc370e463e2bc4b446/WTForms-2.2.1.tar.gz"; sha256 = "0cdbac3e7f6878086c334aa25dc5a33869a3954e9d1e015130d65a69309b3b61"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Babel"
      self."ordereddict"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://wtforms.readthedocs.io/";
        license = licenses.bsdOriginal;
        description = "A flexible forms validation and rendering library for Python web development.";
      };
    };



    "Werkzeug" = python.mkDerivation {
      name = "Werkzeug-0.14.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9f/08/a3bb1c045ec602dc680906fc0261c267bed6b3bb4609430aff92c3888ec8/Werkzeug-0.14.1.tar.gz"; sha256 = "c3fd7a7d41976d9f44db327260e263132466836cef6f91512889ed60ad26557c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.palletsprojects.org/p/werkzeug/";
        license = licenses.bsdOriginal;
        description = "The comprehensive WSGI web application library.";
      };
    };



    "alabaster" = python.mkDerivation {
      name = "alabaster-0.7.11";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3f/46/9346ea429931d80244ab7f11c4fce83671df0b7ae5a60247a2b588592c46/alabaster-0.7.11.tar.gz"; sha256 = "b63b1f4dc77c074d386752ec4a8a7517600f6c0db8cd42980cae17ab7b3275d7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://alabaster.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "A configurable sidebar-enabled Sphinx theme";
      };
    };



    "alembic" = python.mkDerivation {
      name = "alembic-0.8.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f0/7d/7fcda63887d9726e0145e98802baf374ec8cf889325e469194cd7926c98e/alembic-0.8.10.tar.gz"; sha256 = "0e3b50e96218283ec7443fb661199f5a81f5879f766967a8a2d25e8f9d4e7919"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Mako"
      self."SQLAlchemy"
      self."python-editor"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/zzzeek/alembic";
        license = licenses.mit;
        description = "A database migration tool for SQLAlchemy.";
      };
    };



    "amqp" = python.mkDerivation {
      name = "amqp-2.3.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ca/0a/95f9fb2dd71578cb5629261230cb5b8b278c7cce908bca55af8030faceba/amqp-2.3.2.tar.gz"; sha256 = "073dd02fdd73041bffc913b767866015147b61f2a9bc104daef172fc1a0066eb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."vine"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/py-amqp";
        license = licenses.bsdOriginal;
        description = "Low-level AMQP client for Python (fork of amqplib).";
      };
    };



    "apache-airflow" = python.mkDerivation {
      name = "apache-airflow-1.9.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9e/12/6c70f9ef852b3061a3a6c9af03bd9dcdcaecb7d75c8898f82e3a54ad5f87/apache-airflow-1.9.0.tar.gz"; sha256 = "7565b05fa4d3039a6702fe062d79ff63a1c7f3733053a9cb1535163f76b66fa8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."Flask-Admin"
      self."Flask-Bcrypt"
      self."Flask-Cache"
      self."Flask-Login"
      self."Flask-WTF"
      self."GitPython"
      self."JayDeBeApi"
      self."Jinja2"
      self."Markdown"
      self."PyHive"
      self."PySmbClient"
      self."Pygments"
      self."SQLAlchemy"
      self."Sphinx"
      self."Sphinx-PyPI-upload"
      self."alembic"
      self."bcrypt"
      self."bleach"
      self."boto"
      self."boto3"
      self."celery"
      self."cgroupspy"
      self."click"
      self."configparser"
      self."croniter"
      self."cryptography"
      self."dill"
      self."docker-py"
      self."eventlet"
      self."filechunkio"
      self."flask-swagger"
      self."flower"
      self."freezegun"
      self."funcsigs"
      self."future"
      self."gevent"
      self."google-api-python-client"
      self."google-cloud-dataflow"
      self."greenlet"
      self."gunicorn"
      self."hdfs"
      self."hive-thrift-py"
      self."httplib2"
      self."impyla"
      self."jira"
      self."jira"
      self."librabbitmq"
      self."lxml"
      self."mock"
      self."moto"
      self."mysqlclient"
      self."nose"
      self."nose-ignore-docstring"
      self."nose-timer"
      self."oauth2client"
      self."pandas"
      self."pandas-gbq"
      self."parameterized"
      self."paramiko"
      self."psutil"
      self."psycopg2"
      self."pyOpenSSL"
      self."python-daemon"
      self."python-dateutil"
      self."python-nvd3"
      self."qds-sdk"
      self."rednose"
      self."requests"
      self."requests-mock"
      self."setproctitle"
      self."slackclient"
      self."snakebite"
      self."sphinx-argparse"
      self."sphinx-rtd-theme"
      self."tabulate"
      self."thrift"
      self."thrift-sasl"
      self."unicodecsv"
      self."zope.deprecation"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://airflow.incubator.apache.org/";
        license = licenses.asl20;
        description = "Programmatically author, schedule and monitor data pipelines";
      };
    };



    "apache-beam" = python.mkDerivation {
      name = "apache-beam-2.4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e2/66/67444a900ad1b1f61b1c6fd57e59be73b4cc0ef5fed0ba34a62596757ca0/apache-beam-2.4.0.zip"; sha256 = "829db54c10c7157a0e2782e68916802977223798a56bd79d28473b91ab76dd43"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyVCF"
      self."PyYAML"
      self."Sphinx"
      self."avro"
      self."crcmod"
      self."dill"
      self."futures"
      self."google-apitools"
      self."google-cloud-bigquery"
      self."google-cloud-pubsub"
      self."googledatastore"
      self."grpcio"
      self."hdfs"
      self."httplib2"
      self."mock"
      self."oauth2client"
      self."proto-google-cloud-datastore-v1"
      self."protobuf"
      self."six"
      self."typing"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://beam.apache.org";
        license = licenses.asl20;
        description = "Apache Beam SDK for Python";
      };
    };



    "argparse" = python.mkDerivation {
      name = "argparse-1.4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"; sha256 = "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ThomasWaldmann/argparse/";
        license = licenses.psfl;
        description = "Python command-line parsing library";
      };
    };



    "asn1crypto" = python.mkDerivation {
      name = "asn1crypto-0.24.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"; sha256 = "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/wbond/asn1crypto";
        license = licenses.mit;
        description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
      };
    };



    "avro" = python.mkDerivation {
      name = "avro-1.8.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/eb/27/143f124a7498f841317a92ced877150c5cb8d28a4109ec39666485925d00/avro-1.8.2.tar.gz"; sha256 = "8f9ee40830b70b5fb52a419711c9c4ad0336443a6fba7335060805f961b04b59"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://avro.apache.org/";
        license = licenses.asl20;
        description = "Avro is a serialization and RPC framework.";
      };
    };



    "backports-abc" = python.mkDerivation {
      name = "backports-abc-0.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"; sha256 = "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cython/backports_abc";
        license = licenses.psfl;
        description = "A backport of recent additions to the 'collections.abc' module.";
      };
    };



    "backports.ssl-match-hostname" = python.mkDerivation {
      name = "backports.ssl-match-hostname-3.5.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"; sha256 = "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/brandon/backports.ssl_match_hostname";
        license = licenses.psfl;
        description = "The ssl.match_hostname() function from Python 3.5";
      };
    };



    "bcrypt" = python.mkDerivation {
      name = "bcrypt-3.1.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"; sha256 = "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cffi"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyca/bcrypt/";
        license = licenses.asl20;
        description = "Modern password hashing for your software and your servers";
      };
    };



    "billiard" = python.mkDerivation {
      name = "billiard-3.5.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/87/ac/9b3cc065557ad5769d0626fd5dba0ad1cb40e3a72fe6acd3d081b4ad864e/billiard-3.5.0.4.tar.gz"; sha256 = "ed65448da5877b5558f19d2f7f11f8355ea76b3e63e1c0a6059f47cfae5f1c84"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/billiard";
        license = licenses.bsdOriginal;
        description = "Python multiprocessing fork with improvements and bugfixes";
      };
    };



    "bitarray" = python.mkDerivation {
      name = "bitarray-0.8.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e2/1e/b93636ae36d08d0ee3aec40b08731cc97217c69db9422c0afef6ee32ebd2/bitarray-0.8.3.tar.gz"; sha256 = "050cd30b810ddb3aa941e7ddfbe0d8065e793012d0a88cb5739ec23624b9895e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ilanschnell/bitarray";
        license = licenses.psfl;
        description = "efficient arrays of booleans -- C extension";
      };
    };



    "bleach" = python.mkDerivation {
      name = "bleach-2.1.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b3/5f/0da670d30d3ffbc57cc97fa82947f81bbe3eab8d441e2d42e661f215baf2/bleach-2.1.2.tar.gz"; sha256 = "38fc8cbebea4e787d8db55d6f324820c7f74362b70db9142c1ac7920452d1a19"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."html5lib"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mozilla/bleach";
        license = "License :: OSI Approved :: Apache Software License";
        description = "An easy safelist-based HTML-sanitizing tool.";
      };
    };



    "boto" = python.mkDerivation {
      name = "boto-2.49.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"; sha256 = "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/boto/";
        license = licenses.mit;
        description = "Amazon Web Services Library";
      };
    };



    "boto3" = python.mkDerivation {
      name = "boto3-1.7.58";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4f/28/1642a25573c8ffbdcec0ceb09cf5d941f5bc2a0be71179a5d2220e1df3e0/boto3-1.7.58.tar.gz"; sha256 = "ce462e7505c03c3e6708ce6f264ac43d478886082af703ff69c502592df5d4f3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."botocore"
      self."jmespath"
      self."s3transfer"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/boto3";
        license = licenses.asl20;
        description = "The AWS SDK for Python";
      };
    };



    "botocore" = python.mkDerivation {
      name = "botocore-1.10.58";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e5/7b/4f0d1613f33b32a8ad8f65c7973a389244e0aecd209db761f5d51291ebc4/botocore-1.10.58.tar.gz"; sha256 = "e0e6b6d1fdbce81c28151136ee919d2cdeee13041559710cd5c93d7e4035a455"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docutils"
      self."jmespath"
      self."ordereddict"
      self."python-dateutil"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/botocore";
        license = licenses.asl20;
        description = "Low-level, data-driven core of boto 3.";
      };
    };



    "cachetools" = python.mkDerivation {
      name = "cachetools-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/87/41/b3e00059f3c34b57a653d2120d213715abb4327b36fee22e59c1da977d25/cachetools-2.1.0.tar.gz"; sha256 = "90f1d559512fc073483fe573ef5ceb39bf6ad3d39edc98dc55178a2b2b176fa3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tkem/cachetools";
        license = licenses.mit;
        description = "Extensible memoizing collections and decorators";
      };
    };



    "celery" = python.mkDerivation {
      name = "celery-4.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/78/e1/93388de1535bfd7eb65bddda361dcb482a84d373d7c81f8d8d2172caf664/celery-4.2.0.tar.gz"; sha256 = "ff727c115533edbc7b81b2b4ba1ec88d1c2fc4836e1e2f4c3c33a76ff53e5d7f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyYAML"
      self."SQLAlchemy"
      self."billiard"
      self."boto3"
      self."eventlet"
      self."gevent"
      self."kombu"
      self."librabbitmq"
      self."pyOpenSSL"
      self."pytz"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://celeryproject.org";
        license = licenses.bsdOriginal;
        description = "Distributed Task Queue.";
      };
    };



    "certifi" = python.mkDerivation {
      name = "certifi-2018.4.16";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"; sha256 = "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };



    "cffi" = python.mkDerivation {
      name = "cffi-1.11.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"; sha256 = "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pycparser"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cffi.readthedocs.org";
        license = licenses.mit;
        description = "Foreign Function Interface for Python calling C code.";
      };
    };



    "cgroupspy" = python.mkDerivation {
      name = "cgroupspy-0.1.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a5/ad/b37eda48b6be8a13654e823579a9a686d13f60c66b2e97216eced166a2e5/cgroupspy-0.1.6.tar.gz"; sha256 = "fb4aac7938499cff53c260112fb0759a54fb5f8bad89d9be0326c70a7619821a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cloudsigma/cgroupspy";
        license = licenses.bsdOriginal;
        description = "Python library for managing cgroups";
      };
    };



    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"; sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl2;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };



    "click" = python.mkDerivation {
      name = "click-6.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"; sha256 = "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/click";
        license = licenses.bsdOriginal;
        description = "A simple wrapper around optparse for powerful command line utilities.";
      };
    };



    "colorama" = python.mkDerivation {
      name = "colorama-0.3.9";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"; sha256 = "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tartley/colorama";
        license = licenses.bsdOriginal;
        description = "Cross-platform colored terminal text.";
      };
    };



    "configparser" = python.mkDerivation {
      name = "configparser-3.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"; sha256 = "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.python.org/3/library/configparser.html";
        license = licenses.mit;
        description = "This library brings the updated configparser from Python 3.5 to Python 2.6-3.5.";
      };
    };



    "cookies" = python.mkDerivation {
      name = "cookies-2.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f3/95/b66a0ca09c5ec9509d8729e0510e4b078d2451c5e33f47bd6fc33c01517c/cookies-2.2.1.tar.gz"; sha256 = "d6b698788cae4cfa4e62ef8643a9ca332b79bd96cb314294b864ae8d7eb3ee8e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/sashahart/cookies";
        license = licenses.mit;
        description = "Friendlier RFC 6265-compliant cookie parser/renderer";
      };
    };



    "crcmod" = python.mkDerivation {
      name = "crcmod-1.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"; sha256 = "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://crcmod.sourceforge.net/";
        license = licenses.mit;
        description = "CRC Generator";
      };
    };



    "croniter" = python.mkDerivation {
      name = "croniter-0.3.24";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/27/69/2426b76c3647d8cc959e88aadecfb7ad96cf2c40c0ea784b6bf43a844c73/croniter-0.3.24.tar.gz"; sha256 = "4e9cb809d8879372e179cabfb7dc15432815b62be034713cc7d9dc09d62ebf02"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."python-dateutil"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/kiorky/croniter";
        license = licenses.mit;
        description = "croniter provides iteration for datetime object with cron like format";
      };
    };



    "cryptography" = python.mkDerivation {
      name = "cryptography-2.2.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"; sha256 = "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
      self."asn1crypto"
      self."cffi"
      self."enum34"
      self."idna"
      self."ipaddress"
      self."pytz"
      self."six"
      self."sphinx-rtd-theme"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyca/cryptography";
        license = licenses.bsdOriginal;
        description = "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
      };
    };



    "defusedxml" = python.mkDerivation {
      name = "defusedxml-0.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"; sha256 = "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tiran/defusedxml";
        license = licenses.psfl;
        description = "XML bomb protection for Python stdlib modules";
      };
    };



    "dicttoxml" = python.mkDerivation {
      name = "dicttoxml-1.7.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/74/36/534db111db9e7610a41641a1f6669a964aacaf51858f466de264cc8dcdd9/dicttoxml-1.7.4.tar.gz"; sha256 = "ea44cc4ec6c0f85098c57a431a1ee891b3549347b07b7414c8a24611ecf37e45"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/quandyfactory/dicttoxml";
        license = "LICENCE.txt";
        description = "Converts a Python dictionary or other native data type into a valid XML string. ";
      };
    };



    "dill" = python.mkDerivation {
      name = "dill-0.2.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ef/69/0d03d5f9af0e16d41bb47262100b0c4c08f90538c9a5c2de0d44284172ba/dill-0.2.6.zip"; sha256 = "6c1ccca68be483fa8c66e85a89ffc850206c26373aa77a97b83d8d0994e7f1fd"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pypi.org/project/dill";
        license = licenses.bsdOriginal;
        description = "serialize all of python";
      };
    };



    "docker-py" = python.mkDerivation {
      name = "docker-py-1.10.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"; sha256 = "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."backports.ssl-match-hostname"
      self."docker-pycreds"
      self."ipaddress"
      self."requests"
      self."six"
      self."websocket-client"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/docker/docker-py/";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Python client for Docker.";
      };
    };



    "docker-pycreds" = python.mkDerivation {
      name = "docker-pycreds-0.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9e/7a/109e0a3cc3c19534edd843c16e792c67911b5b4072fdd34ddce90d49f355/docker-pycreds-0.3.0.tar.gz"; sha256 = "8b0e956c8d206f832b06aa93a710ba2c3bcbacb5a314449c040b0b814355bbff"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/shin-/dockerpy-creds";
        license = licenses.asl20;
        description = "Python bindings for the docker credentials store API";
      };
    };



    "docopt" = python.mkDerivation {
      name = "docopt-0.6.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"; sha256 = "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docopt.org";
        license = licenses.mit;
        description = "Pythonic argument parser, that will make you smile";
      };
    };



    "docutils" = python.mkDerivation {
      name = "docutils-0.14";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"; sha256 = "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docutils.sourceforge.net/";
        license = licenses.publicDomain;
        description = "Docutils -- Python Documentation Utilities";
      };
    };



    "enum34" = python.mkDerivation {
      name = "enum34-1.1.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"; sha256 = "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/stoneleaf/enum34";
        license = licenses.bsdOriginal;
        description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
      };
    };



    "eventlet" = python.mkDerivation {
      name = "eventlet-0.23.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/72/c5/3f028be460dd4b425b27afd88e3a7380ecb3542a9968271a38ae15682a19/eventlet-0.23.0.tar.gz"; sha256 = "554a50dad7abee0a9775b0780ce9d9c0bd9123dda4743c46d4314170267c6c47"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."enum34"
      self."greenlet"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://eventlet.net";
        license = licenses.mit;
        description = "Highly concurrent networking library";
      };
    };



    "fasteners" = python.mkDerivation {
      name = "fasteners-0.14.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"; sha256 = "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."monotonic"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/harlowja/fasteners";
        license = "License :: OSI Approved :: Apache Software License";
        description = "A python package that provides useful locks.";
      };
    };



    "filechunkio" = python.mkDerivation {
      name = "filechunkio-1.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/10/4d/1789767002fa666fcf486889e8f6a2a90784290be9c0bc28d627efba401e/filechunkio-1.8.tar.gz"; sha256 = "c8540c2d27e851d3a475b2e14ac109d66c777dd43ab67031891c826e82026745"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/fabian/filechunkio";
        license = "MIT license";
        description = "FileChunkIO represents a chunk of an OS-level file containing bytes data";
      };
    };



    "flask-swagger" = python.mkDerivation {
      name = "flask-swagger-0.2.13";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/68/97/4e31ac3dc4a44a4b7487eab8404a68c871b57a15811e189862d0bf0c5b55/flask-swagger-0.2.13.tar.gz"; sha256 = "42420efbed1aad86f7ca6bb869df550e09591e1d540ebd3040c197906c0f0be6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."PyYAML"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gangverk/flask-swagger";
        license = licenses.mit;
        description = "Extract swagger specs from your flask project";
      };
    };



    "flower" = python.mkDerivation {
      name = "flower-0.9.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/48/7f/344a8f93cbd6669b4fd03c04d8f9a06e9023da7b61145dea5836433bbbe5/flower-0.9.2.tar.gz"; sha256 = "a7a828c2dbea7e9cff1c86d63626f0eeb047b1b1e9a0ee5daad30771fb51e6d0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Babel"
      self."celery"
      self."futures"
      self."pytz"
      self."tornado"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mher/flower";
        license = licenses.bsdOriginal;
        description = "Celery Flower";
      };
    };



    "freezegun" = python.mkDerivation {
      name = "freezegun-0.3.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1d/3c/fd18e8fdb662370baedae516df1b20aec9c98a6fcf5d93ff8334835552d7/freezegun-0.3.10.tar.gz"; sha256 = "703caac155dcaad61f78de4cb0666dca778d854dfb90b3699930adee0559a622"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."python-dateutil"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/spulec/freezegun";
        license = licenses.asl20;
        description = "Let your Python tests travel through time";
      };
    };



    "funcsigs" = python.mkDerivation {
      name = "funcsigs-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b9/5e/55612c62d35959b5b9767f020f95cb0830f340733f5c2626c7d1e9056729/funcsigs-1.0.0.tar.gz"; sha256 = "2310f9d4a77c284e920ec572dc2525366a107b08d216ff8dbb891d95b6a77563"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."ordereddict"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://funcsigs.readthedocs.org";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
      };
    };



    "future" = python.mkDerivation {
      name = "future-0.16.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"; sha256 = "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://python-future.org";
        license = licenses.mit;
        description = "Clean single-source support for Python 3 and 2";
      };
    };



    "futures" = python.mkDerivation {
      name = "futures-3.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb/futures-3.2.0.tar.gz"; sha256 = "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/agronholm/pythonfutures";
        license = licenses.psfl;
        description = "Backport of the concurrent.futures package from Python 3";
      };
    };



    "gapic-google-cloud-pubsub-v1" = python.mkDerivation {
      name = "gapic-google-cloud-pubsub-v1-0.15.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/bc/a7/0225bd7a95e037a0afa90b2dd9534d0c79cd62283a5bddb30a3197579cbc/gapic-google-cloud-pubsub-v1-0.15.4.tar.gz"; sha256 = "a8cd1d89542085e3b05ca15632b9067a1e45f8c98eb05f3e3ffc25129c694745"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-gax"
      self."googleapis-common-protos"
      self."grpc-google-iam-v1"
      self."oauth2client"
      self."proto-google-cloud-pubsub-v1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = "License :: OSI Approved :: Apache Software License";
        description = "GAPIC library for the Google Cloud Pub/Sub API";
      };
    };



    "gevent" = python.mkDerivation {
      name = "gevent-1.3.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f8/85/f92a8f43c9f15ffad49d743d929863a042ce3e8de5746c63bb4d6ce51a02/gevent-1.3.4.tar.gz"; sha256 = "53c4dc705886d028f5d81e698b1d1479994a421498cd6529cb9711b5e2a84f74"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cffi"
      self."futures"
      self."greenlet"
      self."idna"
      self."mock"
      self."psutil"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.gevent.org/";
        license = licenses.mit;
        description = "Coroutine-based network library";
      };
    };



    "gitdb2" = python.mkDerivation {
      name = "gitdb2-2.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b9/36/4bdb753087a9232899ac482ee2d5da25f50b63998d661aa4e8170acd95b5/gitdb2-2.0.4.tar.gz"; sha256 = "bb4c85b8a58531c51373c89f92163b92f30f81369605a67cd52d1fc21246c044"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."smmap2"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gitpython-developers/gitdb";
        license = licenses.bsdOriginal;
        description = "Git Object Database";
      };
    };



    "google-api-python-client" = python.mkDerivation {
      name = "google-api-python-client-1.5.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a7/4e/1278995cd1e50b9cdb6b04981db91290b5aedca8fba48b9f83c7dba05f6d/google-api-python-client-1.5.5.tar.gz"; sha256 = "c9f6bf15c76b05a3c2e301a5509e97f11c5902fb6b03dcb7faf5b5337c66f557"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."httplib2"
      self."oauth2client"
      self."six"
      self."uritemplate"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/google-api-python-client/";
        license = licenses.asl20;
        description = "Google API Client Library for Python";
      };
    };



    "google-apitools" = python.mkDerivation {
      name = "google-apitools-0.5.20";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/56/c3/ddeee7b43e27e9b319728094831f50e85f4c0b7677b34bc562ec8a70a4e5/google-apitools-0.5.20.tar.gz"; sha256 = "0f854ff8946c97bf547adfb89351e51949fb41e127c962d020776dda7a24e1d0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."fasteners"
      self."httplib2"
      self."mock"
      self."oauth2client"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/craigcitro/apitools";
        license = licenses.asl20;
        description = "client libraries for humans";
      };
    };



    "google-auth" = python.mkDerivation {
      name = "google-auth-1.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a2/39/0c3d41aa96c1bdb9dcc4f646909b82e4c0ed9a1a398e869627a21a0563c4/google-auth-1.5.0.tar.gz"; sha256 = "1745c9066f698eac3da99cef082914495fb71bc09597ba7626efbbb64c4acc57"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cachetools"
      self."pyasn1-modules"
      self."rsa"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python";
        license = licenses.asl20;
        description = "Google Authentication Library";
      };
    };



    "google-auth-httplib2" = python.mkDerivation {
      name = "google-auth-httplib2-0.0.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e7/32/ac7f30b742276b4911a1439c5291abab1b797ccfd30bc923c5ad67892b13/google-auth-httplib2-0.0.3.tar.gz"; sha256 = "098fade613c25b4527b2c08fa42d11f3c2037dda8995d86de0745228e965d445"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-auth"
      self."httplib2"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
        license = licenses.asl20;
        description = "Google Authentication Library: httplib2 transport";
      };
    };



    "google-auth-oauthlib" = python.mkDerivation {
      name = "google-auth-oauthlib-0.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8a/37/f0f965ac854d4512c554cffce25bd23e61a0700bb8c8542f4dc1e75412e6/google-auth-oauthlib-0.2.0.tar.gz"; sha256 = "226d1d0960f86ba5d9efd426a70b291eaba96f47d071657e0254ea969025728a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."click"
      self."google-auth"
      self."requests-oauthlib"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
        license = licenses.asl20;
        description = "Google Authentication Library";
      };
    };



    "google-cloud-bigquery" = python.mkDerivation {
      name = "google-cloud-bigquery-0.25.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4a/f1/05631b0a29b1f763794404195d161edb24d7463029c987e0a32fc521e2a6/google-cloud-bigquery-0.25.0.tar.gz"; sha256 = "6e8cc6914701bbfd8845cc0e0b19c5e2123649fc6ddc49aa945d83629499f4ec"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-cloud-core"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Python Client for Google BigQuery";
      };
    };



    "google-cloud-core" = python.mkDerivation {
      name = "google-cloud-core-0.25.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/58/d0/c3a30eca2a0073d5ac00254a1a9d259929a899deee6e3dfe4e45264f5187/google-cloud-core-0.25.0.tar.gz"; sha256 = "1249ee44c445f820eaf99d37904b37961347019dcd3637dbad1f3173260245f2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-auth"
      self."google-auth-httplib2"
      self."googleapis-common-protos"
      self."httplib2"
      self."protobuf"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "API Client library for Google Cloud: Core Helpers";
      };
    };



    "google-cloud-dataflow" = python.mkDerivation {
      name = "google-cloud-dataflow-2.4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3b/6b/165eb940a26b16ee27cee2643938e23955c54f6042e7e241b2d6afea8cea/google-cloud-dataflow-2.4.0.tar.gz"; sha256 = "e7cb174d9062869694f38cf55f5347d19fd22d681c6df4a509aec0078904c0df"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."apache-beam"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://cloud.google.com/dataflow/";
        license = licenses.asl20;
        description = "Google Cloud Dataflow SDK for Python, based on Apache Beam";
      };
    };



    "google-cloud-pubsub" = python.mkDerivation {
      name = "google-cloud-pubsub-0.26.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a0/98/7bc392f8d35fc7d4d0a37ca377538ad3881e436adbca3886a24ebcf89b54/google-cloud-pubsub-0.26.0.tar.gz"; sha256 = "80332d93580cd9bcd6fee4c8e64f6aed04f7f92298d3f6cb5c8f4224c871c7b8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."gapic-google-cloud-pubsub-v1"
      self."google-cloud-core"
      self."grpcio"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Python Client for Google Cloud Pub/Sub";
      };
    };



    "google-gax" = python.mkDerivation {
      name = "google-gax-0.15.16";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4e/88/f5ac2a37bc5170550c2dd8dace7568cef600734e10cd10369c37efffab35/google-gax-0.15.16.tar.gz"; sha256 = "518e8d5eb90774af2041080d242f4bcec4c6e653226c693901eaf82eda8a395c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."dill"
      self."future"
      self."google-auth"
      self."googleapis-common-protos"
      self."grpcio"
      self."ply"
      self."protobuf"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/gax-python";
        license = licenses.bsdOriginal;
        description = "Google API Extensions";
      };
    };



    "googleapis-common-protos" = python.mkDerivation {
      name = "googleapis-common-protos-1.5.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/00/03/d25bed04ec8d930bcfa488ba81a2ecbf7eb36ae3ffd7e8f5be0d036a89c9/googleapis-common-protos-1.5.3.tar.gz"; sha256 = "c075eddaa2628ab519e01b7d75b76e66c40eaa50fc52758d8225f84708950ef2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."grpcio"
      self."protobuf"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Common protobufs used in Google APIs";
      };
    };



    "googledatastore" = python.mkDerivation {
      name = "googledatastore-7.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/73/d0/17ce873331aaf529ab238464a15fd7bdc1ba8d2c684789970a7fa8b505a8/googledatastore-7.0.1.tar.gz"; sha256 = "963e6cec4d8ac47ad02f451e61062156676d269d6d8ba9711464033509308f16"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."httplib2"
      self."oauth2client"
      self."proto-google-cloud-datastore-v1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-datastore";
        license = "License :: OSI Approved :: Apache Software License";
        description = "google cloud datastore protobuf client";
      };
    };



    "greenlet" = python.mkDerivation {
      name = "greenlet-0.4.13";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/13/de/ba92335e9e76040ca7274224942282a80d54f85e342a5e33c5277c7f87eb/greenlet-0.4.13.tar.gz"; sha256 = "0fef83d43bf87a5196c91e73cb9772f945a4caaff91242766c5916d1dd1381e4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python-greenlet/greenlet";
        license = licenses.mit;
        description = "Lightweight in-process concurrent programming";
      };
    };



    "grpc-google-iam-v1" = python.mkDerivation {
      name = "grpc-google-iam-v1-0.11.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9b/28/f26f67381cb23e81271b8d66c00a846ad9d25a909ae1ae1df8222fad2744/grpc-google-iam-v1-0.11.4.tar.gz"; sha256 = "5009e831dcec22f3ff00e89405249d6a838d1449a46ac8224907aa5b0e0b1aec"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."googleapis-common-protos"
      self."grpcio"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = "License :: OSI Approved :: Apache Software License";
        description = "GRPC library for the google-iam-v1 service";
      };
    };



    "grpcio" = python.mkDerivation {
      name = "grpcio-1.13.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e6/27/1f138a6f8691b8d1c1a4f2005f9293da6641c806d5626eb6c43e765962b1/grpcio-1.13.0.tar.gz"; sha256 = "6324581e215157f0fbe335dff2e21a65b4406db98ac7cca05f1e23b4f510b426"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."enum34"
      self."futures"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://grpc.io";
        license = licenses.asl20;
        description = "HTTP/2-based RPC framework";
      };
    };



    "gunicorn" = python.mkDerivation {
      name = "gunicorn-19.9.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/47/52/68ba8e5e8ba251e54006a49441f7ccabca83b6bef5aedacb4890596c7911/gunicorn-19.9.0.tar.gz"; sha256 = "fa2662097c66f920f53f70621c6c58ca4a3c4d3434205e608e121b5b3b71f4f3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."eventlet"
      self."futures"
      self."gevent"
      self."tornado"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://gunicorn.org";
        license = licenses.mit;
        description = "WSGI HTTP Server for UNIX";
      };
    };



    "hdfs" = python.mkDerivation {
      name = "hdfs-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/bb/ef/35af4764ea6c60bd14195ca78d4e831d154183f35cc4af4a0b3e01aa28ce/hdfs-2.1.0.tar.gz"; sha256 = "a40fe99ccb03b5c3247b33a4110eb21b57405dd7c3f1b775e362e66c19b44bc6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docopt"
      self."pandas"
      self."requests"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://hdfscli.readthedocs.io";
        license = licenses.mit;
        description = "HdfsCLI: API and command line interface for HDFS.";
      };
    };



    "hive-thrift-py" = python.mkDerivation {
      name = "hive-thrift-py-0.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b1/29/89bad48229d0e7d478c47e2e9dbe9c96828167d0cc19a6898914a1874539/hive-thrift-py-0.0.1.tar.gz"; sha256 = "c0b2554527beb040c8009b7af9f363f0498df2f985746c8dfd6cc41fdce3d6e1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://hive.apache.org";
        license = "Apache License";
        description = "Hive Python Thrift Libs";
      };
    };



    "html5lib" = python.mkDerivation {
      name = "html5lib-1.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"; sha256 = "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."chardet"
      self."lxml"
      self."six"
      self."webencodings"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/html5lib/html5lib-python";
        license = licenses.mit;
        description = "HTML parser based on the WHATWG HTML specification";
      };
    };



    "httplib2" = python.mkDerivation {
      name = "httplib2-0.9.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ff/a9/5751cdf17a70ea89f6dde23ceb1705bfb638fd8cee00f845308bf8d26397/httplib2-0.9.2.tar.gz"; sha256 = "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jcgregorio/httplib2";
        license = licenses.mit;
        description = "A comprehensive HTTP client library.";
      };
    };



    "idna" = python.mkDerivation {
      name = "idna-2.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"; sha256 = "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };



    "imagesize" = python.mkDerivation {
      name = "imagesize-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c6/3f/1db2da33804e8d7ef3a868b27b7bdc1aae6a4f693f0162d2aeeaf503864f/imagesize-1.0.0.tar.gz"; sha256 = "5b326e4678b6925158ccc66a9fa3122b6106d7c876ee32d7de6ce59385b96315"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/shibukawa/imagesize_py";
        license = licenses.mit;
        description = "Getting image size from png/jpeg/jpeg2000/gif file";
      };
    };



    "impyla" = python.mkDerivation {
      name = "impyla-0.13.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/09/c6/177005869e88d6c5440d11a6a26b9a24813757c32d2c5d6406aa81e5f9f0/impyla-0.13.3.tar.gz"; sha256 = "a2c489bfb8317af17bee11c85a90e27af4b8c387fdc0ff797add617501ddb434"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."bitarray"
      self."sasl"
      self."six"
      self."thrift"
      self."thrift-sasl"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cloudera/impyla";
        license = licenses.asl20;
        description = "Python client for the Impala distributed query engine";
      };
    };



    "inflection" = python.mkDerivation {
      name = "inflection-0.3.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d5/35/a6eb45b4e2356fe688b21570864d4aa0d0a880ce387defe9c589112077f8/inflection-0.3.1.tar.gz"; sha256 = "18ea7fb7a7d152853386523def08736aa8c32636b047ade55f7578c4edeb16ca"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/jpvanhal/inflection";
        license = licenses.mit;
        description = "A port of Ruby on Rails inflector to Python";
      };
    };



    "ipaddress" = python.mkDerivation {
      name = "ipaddress-1.0.22";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"; sha256 = "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/phihag/ipaddress";
        license = licenses.psfl;
        description = "IPv4/IPv6 manipulation library";
      };
    };



    "itsdangerous" = python.mkDerivation {
      name = "itsdangerous-0.24";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz"; sha256 = "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/itsdangerous";
        license = licenses.bsdOriginal;
        description = "Various helpers to pass trusted data to untrusted environments and back.";
      };
    };



    "jira" = python.mkDerivation {
      name = "jira-2.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/98/25/22de2a31d679e23b0865d6c39c6fd8e28da0bcfea3a1da1eeee0e4fdd286/jira-2.0.0.tar.gz"; sha256 = "e2a94adff98e45b29ded030adc76103eab34fa7d4d57303f211f572bedba0e93"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyJWT"
      self."argparse"
      self."defusedxml"
      self."oauthlib"
      self."pbr"
      self."requests"
      self."requests-oauthlib"
      self."requests-toolbelt"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pycontribs/jira";
        license = licenses.bsdOriginal;
        description = "Python library for interacting with JIRA via REST APIs.";
      };
    };



    "jmespath" = python.mkDerivation {
      name = "jmespath-0.9.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"; sha256 = "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jmespath/jmespath.py";
        license = licenses.mit;
        description = "JSON Matching Expressions";
      };
    };



    "kombu" = python.mkDerivation {
      name = "kombu-4.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/39/9f/556b988833abede4a80dbd18b2bdf4e8ff4486dd482ed45da961347e8ed2/kombu-4.2.1.tar.gz"; sha256 = "86adec6c60f63124e2082ea8481bbe4ebe04fde8ebed32c177c7f0cd2c1c9082"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyYAML"
      self."SQLAlchemy"
      self."amqp"
      self."boto3"
      self."librabbitmq"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://kombu.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Messaging library for Python.";
      };
    };



    "librabbitmq" = python.mkDerivation {
      name = "librabbitmq-1.6.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/82/6c/1b3f7ca755787e934513039131091134038239f167e1bc50565cb46112a0/librabbitmq-1.6.1.tar.gz"; sha256 = "604a226b9fe3f9e439353702a731f2a39cf771882e68bca020cb224d9b990c49"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."amqp"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/librabbitmq";
        license = licenses.mpl10;
        description = "AMQP Client using the rabbitmq-c library.";
      };
    };



    "lockfile" = python.mkDerivation {
      name = "lockfile-0.12.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"; sha256 = "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://launchpad.net/pylockfile";
        license = licenses.mit;
        description = "Platform-independent file locking module";
      };
    };



    "lxml" = python.mkDerivation {
      name = "lxml-3.8.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/20/b3/9f245de14b7696e2d2a386c0b09032a2ff6625270761d6543827e667d8de/lxml-3.8.0.tar.gz"; sha256 = "736f72be15caad8116891eb6aa4a078b590d231fdc63818c40c21624ac71db96"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."html5lib"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://lxml.de/";
        license = licenses.bsdOriginal;
        description = "Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.";
      };
    };



    "mock" = python.mkDerivation {
      name = "mock-2.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"; sha256 = "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
      self."Pygments"
      self."Sphinx"
      self."funcsigs"
      self."pbr"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/testing-cabal/mock";
        license = licenses.bsdOriginal;
        description = "Rolling backport of unittest.mock for all Pythons";
      };
    };



    "monotonic" = python.mkDerivation {
      name = "monotonic-1.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"; sha256 = "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/atdt/monotonic";
        license = "License :: OSI Approved :: Apache Software License";
        description = "An implementation of time.monotonic() for Python 2 & < 3.3";
      };
    };



    "moto" = python.mkDerivation {
      name = "moto-1.1.19";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/61/66/c6fbeb544fe03e38c95dc36d3de998d6151c83a9d548615d310812602b6a/moto-1.1.19.tar.gz"; sha256 = "3657fa0b44a5a4e41be7613aa648ca5e5b7e79a422d6c2e380272a8923a22fcc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."Jinja2"
      self."Werkzeug"
      self."boto"
      self."boto3"
      self."cookies"
      self."cryptography"
      self."dicttoxml"
      self."mock"
      self."pyaml"
      self."python-dateutil"
      self."pytz"
      self."requests"
      self."six"
      self."xmltodict"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/spulec/moto";
        license = "License :: OSI Approved :: Apache Software License";
        description = "A library that allows your python tests to easily mock out the boto library";
      };
    };



    "mysqlclient" = python.mkDerivation {
      name = "mysqlclient-1.3.13";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ec/fd/83329b9d3e14f7344d1cb31f128e6dbba70c5975c9e57896815dbb1988ad/mysqlclient-1.3.13.tar.gz"; sha256 = "ff8ee1be84215e6c30a746b728c41eb0701a46ca76e343af445b35ce6250644f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/PyMySQL/mysqlclient-python";
        license = licenses.gpl1;
        description = "Python interface to MySQL";
      };
    };



    "nose" = python.mkDerivation {
      name = "nose-1.3.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"; sha256 = "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://readthedocs.org/docs/nose/";
        license = licenses.lgpl2;
        description = "nose extends unittest to make testing easier";
      };
    };



    "nose-ignore-docstring" = python.mkDerivation {
      name = "nose-ignore-docstring-0.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b9/cb/8594946a890c1570acd7ed6aac894196570fe4bbb3c9e487cf8297b2fa78/nose-ignore-docstring-0.2.tar.gz"; sha256 = "f58aea0e3ff5e749c3b0e09810d31b47c6d3eea81de23cdecb46de53bcd43a77"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/schlamar/nose-ignore-docstring";
        license = licenses.mit;
        description = "Ignore docstring to name tests in nose.";
      };
    };



    "nose-timer" = python.mkDerivation {
      name = "nose-timer-0.7.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/78/52/47f773612fd9c0ef965474616f40790b4329c28872342af41cbeb8e8c19a/nose-timer-0.7.3.tar.gz"; sha256 = "84743e05fc940868f5b6e379ed2a3f7da3fa49cdd72c3f531c893868b12adf41"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."nose"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mahmoudimus/nose-timer";
        license = licenses.mit;
        description = "A timer plugin for nosetests";
      };
    };



    "numpy" = python.mkDerivation {
      name = "numpy-1.14.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d5/6e/f00492653d0fdf6497a181a1c1d46bbea5a2383e7faf4c8ca6d6f3d2581d/numpy-1.14.5.zip"; sha256 = "a4a433b3a264dbc9aa9c7c241e87c0358a503ea6394f8737df1683c7c9a102ac"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.numpy.org";
        license = licenses.bsdOriginal;
        description = "NumPy: array processing for numbers, strings, records, and objects.";
      };
    };



    "oauth2client" = python.mkDerivation {
      name = "oauth2client-2.0.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a7/70/95d5fb8b839c2c33e8ed76cc0cc060bd57d6506746790a753137df9ebd60/oauth2client-2.0.2.tar.gz"; sha256 = "c9f7bf68e9d0f9ec055f1f2f487e5ea53b97b7a2b82f01d48d9a9bb68239535a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."httplib2"
      self."pyasn1"
      self."pyasn1-modules"
      self."rsa"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/oauth2client/";
        license = licenses.asl20;
        description = "OAuth 2.0 client library";
      };
    };



    "oauthlib" = python.mkDerivation {
      name = "oauthlib-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"; sha256 = "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyJWT"
      self."cryptography"
      self."mock"
      self."nose"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/oauthlib/oauthlib";
        license = licenses.bsdOriginal;
        description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
      };
    };



    "ordereddict" = python.mkDerivation {
      name = "ordereddict-1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"; sha256 = "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = "";
        description = "UNKNOWN";
      };
    };



    "packaging" = python.mkDerivation {
      name = "packaging-17.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"; sha256 = "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyparsing"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/packaging";
        license = licenses.bsdOriginal;
        description = "Core utilities for Python packages";
      };
    };



    "pandas" = python.mkDerivation {
      name = "pandas-0.23.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3e/56/82c4d4c049294f87ebd05b65fdcbc9ed68bd23fb0a7e4469caf9a75d199f/pandas-0.23.3.tar.gz"; sha256 = "9cd3614b4e31a0889388ff1bd19ae857ad52658b33f776065793c293a29cf612"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."numpy"
      self."python-dateutil"
      self."pytz"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pandas.pydata.org";
        license = licenses.bsdOriginal;
        description = "Powerful data structures for data analysis, time series, and statistics";
      };
    };



    "pandas-gbq" = python.mkDerivation {
      name = "pandas-gbq-0.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f8/a3/f3b2a70cd687bf818dcc134320840552c0c9bd3b589e3f9c3ee6bba861f7/pandas-gbq-0.5.0.tar.gz"; sha256 = "0a8be4171581cbd5e101392a61cb8d0b4b0993fd343ab57f4a03616cf70a62af"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-auth"
      self."google-auth-oauthlib"
      self."google-cloud-bigquery"
      self."pandas"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pydata/pandas-gbq";
        license = licenses.bsdOriginal;
        description = "Pandas interface to Google BigQuery";
      };
    };



    "parameterized" = python.mkDerivation {
      name = "parameterized-0.6.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/77/b6/8c481344c63b3eadeaa26f62b9d7ce4221a52bad390da5f059573d4c7ee4/parameterized-0.6.1.tar.gz"; sha256 = "caf58e717097735de0d7e15386a46ffa5ce25bb6a13a43716a8854a8d34841e2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/wolever/parameterized";
        license = licenses.bsdOriginal;
        description = "Parameterized testing with any Python test framework";
      };
    };



    "paramiko" = python.mkDerivation {
      name = "paramiko-2.4.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/29/65/83181630befb17cd1370a6abb9a87957947a43c2332216e5975353f61d64/paramiko-2.4.1.tar.gz"; sha256 = "33e36775a6c71790ba7692a73f948b329cf9295a72b0102144b031114bd2a4f3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyNaCl"
      self."bcrypt"
      self."cryptography"
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/paramiko/paramiko/";
        license = licenses.lgpl2;
        description = "SSH2 protocol library";
      };
    };



    "pbr" = python.mkDerivation {
      name = "pbr-4.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/04/69/25fb4c68ae8093cf7698cec37dbbfdd3f6161ccd94a407aea0c6c1d8ce29/pbr-4.1.0.tar.gz"; sha256 = "e0f23b61ec42473723b2fec2f33fb12558ff221ee551962f01dd4de9053c2055"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.openstack.org/pbr/latest/";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Python Build Reasonableness";
      };
    };



    "ply" = python.mkDerivation {
      name = "ply-3.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/96/e0/430fcdb6b3ef1ae534d231397bee7e9304be14a47a267e82ebcb3323d0b5/ply-3.8.tar.gz"; sha256 = "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.dabeaz.com/ply/";
        license = licenses.bsdOriginal;
        description = "Python Lex & Yacc";
      };
    };



    "proto-google-cloud-datastore-v1" = python.mkDerivation {
      name = "proto-google-cloud-datastore-v1-0.90.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2a/1f/4124f15e1132a2eeeaf616d825990bb1d395b4c2c37362654ea5cd89bb42/proto-google-cloud-datastore-v1-0.90.4.tar.gz"; sha256 = "a431bb6a286107900c9ce3c48d316378867293c50a4d8a6c7393264600e916f9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."googleapis-common-protos"
      self."grpcio"
      self."oauth2client"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = "License :: OSI Approved :: Apache Software License";
        description = "GRPC library for the Google Cloud Datastore API";
      };
    };



    "proto-google-cloud-pubsub-v1" = python.mkDerivation {
      name = "proto-google-cloud-pubsub-v1-0.15.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c0/a2/2eeffa0069830f00016196dfdd69491cf562372b5353f2e8e378b3c2cb0a/proto-google-cloud-pubsub-v1-0.15.4.tar.gz"; sha256 = "74549d55cd492744cff255e8ab2c4df81153be06c08fb6345131fd034976d235"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."googleapis-common-protos"
      self."grpcio"
      self."oauth2client"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = "License :: OSI Approved :: Apache Software License";
        description = "GRPC library for the Google Cloud Pub/Sub API";
      };
    };



    "protobuf" = python.mkDerivation {
      name = "protobuf-3.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/7f/51/7429b4009ccd54717d54b3a273d16df1a269845b39bcca3b4b7023a48078/protobuf-3.6.0.tar.gz"; sha256 = "a37836aa47d1b81c2db1a6b7a5e79926062b5d76bd962115a0e615551be2b48d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://developers.google.com/protocol-buffers/";
        license = "3-Clause BSD License";
        description = "Protocol Buffers";
      };
    };



    "psutil" = python.mkDerivation {
      name = "psutil-4.4.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6c/49/0f784a247868e167389f6ac76b8699b2f3d6f4e8e85685dfec43e58d1ed1/psutil-4.4.2.tar.gz"; sha256 = "1c37e6428f7fe3aeea607f9249986d9bb933bb98133c7919837fd9aac4996b07"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/giampaolo/psutil";
        license = licenses.bsdOriginal;
        description = "psutil is a cross-platform library for retrieving information onrunning processes and system utilization (CPU, memory, disks, network)in Python.";
      };
    };



    "psycopg2" = python.mkDerivation {
      name = "psycopg2-2.7.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b2/c1/7bf6c464e903ffc4f3f5907c389e5a4199666bf57f6cd6bf46c17912a1f9/psycopg2-2.7.5.tar.gz"; sha256 = "eccf962d41ca46e6326b97c8fe0a6687b58dfc1a5f6540ed071ff1474cea749e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://initd.org/psycopg/";
        license = licenses.lgpl2;
        description = "psycopg2 - Python-PostgreSQL Database Adapter";
      };
    };



    "pyOpenSSL" = python.mkDerivation {
      name = "pyOpenSSL-18.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"; sha256 = "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
      self."cryptography"
      self."six"
      self."sphinx-rtd-theme"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pyopenssl.org/";
        license = licenses.asl20;
        description = "Python wrapper module around the OpenSSL library";
      };
    };



    "pyaml" = python.mkDerivation {
      name = "pyaml-17.12.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9e/17/1d4ed6e1a4c0918a0357dfa2fdbe26bf63f6e616013c04a14bce9fd33e40/pyaml-17.12.1.tar.gz"; sha256 = "66623c52f34d83a2c0fc963e08e8b9d0c13d88404e3b43b1852ef71eda19afa3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyYAML"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mk-fg/pretty-yaml";
        license = "WTFPL";
        description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
      };
    };



    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0d/33/3466a3210321a02040e3ab2cd1ffc6f44664301a5d650a7e44be1dc341f2/pyasn1-0.4.3.tar.gz"; sha256 = "fb81622d8f3509f0026b0683fe90fea27be7284d3826a5f2edf97f69151ab0fc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };



    "pyasn1-modules" = python.mkDerivation {
      name = "pyasn1-modules-0.2.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/37/33/74ebdc52be534e683dc91faf263931bc00ae05c6073909fde53999088541/pyasn1-modules-0.2.2.tar.gz"; sha256 = "a0cf3e1842e7c60fde97cb22d275eb6f9524f5c5250489e292529de841417547"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1-modules";
        license = licenses.bsdOriginal;
        description = "A collection of ASN.1-based protocols modules.";
      };
    };



    "pycparser" = python.mkDerivation {
      name = "pycparser-2.18";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"; sha256 = "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/eliben/pycparser";
        license = licenses.bsdOriginal;
        description = "C parser in Python";
      };
    };



    "pyparsing" = python.mkDerivation {
      name = "pyparsing-2.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"; sha256 = "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pyparsing.wikispaces.com/";
        license = licenses.mit;
        description = "Python parsing module";
      };
    };



    "python-daemon" = python.mkDerivation {
      name = "python-daemon-2.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ae/e4/82870b5e01d761a04597fa332e4aaf285acfa1e675350fda55c6686f16ef/python-daemon-2.1.1.tar.gz"; sha256 = "58a8c187ee37c3a28913bef00f83240c9ecd4a59dce09a24d92f5c941606689f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docutils"
      self."lockfile"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://alioth.debian.org/projects/python-daemon/";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Library to implement a well-behaved Unix daemon process.";
      };
    };



    "python-dateutil" = python.mkDerivation {
      name = "python-dateutil-2.7.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"; sha256 = "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://dateutil.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Extensions to the standard Python datetime module";
      };
    };



    "python-editor" = python.mkDerivation {
      name = "python-editor-1.0.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/65/1e/adf6e000ea5dc909aa420352d6ba37f16434c8a3c2fa030445411a1ed545/python-editor-1.0.3.tar.gz"; sha256 = "a3c066acee22a1c94f63938341d4fb374e3fdd69366ed6603d7b24bed1efc565"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/fmoo/python-editor";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Programmatically open an editor, capture the result.";
      };
    };



    "python-nvd3" = python.mkDerivation {
      name = "python-nvd3-0.14.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/30/68/5d5d7c1a46de23f1da3b4a7035ac305b76aba582648d19cd9da89b5bd8f6/python-nvd3-0.14.2.tar.gz"; sha256 = "86ca51a9526ced2ebe8faff999b0660755f51f2d00af7871efba9b777470ae95"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
      self."python-slugify"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/areski/python-nvd3";
        license = licenses.mit;
        description = "Python NVD3 - Chart Library for d3.js";
      };
    };



    "python-slugify" = python.mkDerivation {
      name = "python-slugify-1.1.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2e/13/838ba9b35375ed05bc3b959c81f22ef49e7bdb426063bee888d6f2dc84f0/python-slugify-1.1.4.tar.gz"; sha256 = "e674f0d45eaeb5c47b7d4771319889a39b15ee87aa62c3b2fcc33cf34e94fc98"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Unidecode"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/un33k/python-slugify";
        license = licenses.bsdOriginal;
        description = "A Python Slugify application that handles Unicode";
      };
    };



    "pytz" = python.mkDerivation {
      name = "pytz-2018.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"; sha256 = "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pythonhosted.org/pytz";
        license = licenses.mit;
        description = "World timezone definitions, modern and historical";
      };
    };



    "qds-sdk" = python.mkDerivation {
      name = "qds-sdk-1.9.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e2/87/cf3e5839680551486a314e27fc14f3e7842c2c252c1679ad6b4909da094f/qds_sdk-1.9.8.tar.gz"; sha256 = "770250e8738910d7aa18876783c1a3b980e20e204be3d700e62845ec110774a5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."boto"
      self."inflection"
      self."requests"
      self."six"
      self."urllib3"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/qubole/qds-sdk-py";
        license = licenses.asl20;
        description = "Python SDK for coding to the Qubole Data Service API";
      };
    };



    "rednose" = python.mkDerivation {
      name = "rednose-1.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3a/a8/4b73ae7466c2e9b63b3c4d66040d1c0eda1f764812353753702546d8c87f/rednose-1.3.0.tar.gz"; sha256 = "6da77917788be277b70259edc0bb92fc6f28fe268b765b4ea88206cc3543a3e1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."colorama"
      self."termstyle"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/JBKahn/rednose";
        license = licenses.mit;
        description = "coloured output for nosetests";
      };
    };



    "requests" = python.mkDerivation {
      name = "requests-2.19.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"; sha256 = "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."chardet"
      self."cryptography"
      self."idna"
      self."pyOpenSSL"
      self."urllib3"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };



    "requests-mock" = python.mkDerivation {
      name = "requests-mock-1.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/24/d5/7b5254b87c50e837810a082b87c2f85aa86b99c23a83d8120c27e24d04c9/requests-mock-1.5.0.tar.gz"; sha256 = "a029fe6c5244963ef042c6224ff787049bfc5bab958a1b7e5b632ef0bbb05de4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
      self."mock"
      self."requests"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://requests-mock.readthedocs.org/";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Mock out responses from the requests package";
      };
    };



    "requests-oauthlib" = python.mkDerivation {
      name = "requests-oauthlib-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/95/be/072464f05b70e4142cb37151e215a2037b08b1400f8a56f2538b76ca6205/requests-oauthlib-1.0.0.tar.gz"; sha256 = "8886bfec5ad7afb391ed5443b1f697c6f4ae98d0e5620839d8b4499c032ada3f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."oauthlib"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/requests/requests-oauthlib";
        license = licenses.bsdOriginal;
        description = "OAuthlib authentication support for Requests.";
      };
    };



    "requests-toolbelt" = python.mkDerivation {
      name = "requests-toolbelt-0.8.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/86/f9/e80fa23edca6c554f1994040064760c12b51daff54b55f9e379e899cd3d4/requests-toolbelt-0.8.0.tar.gz"; sha256 = "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://toolbelt.readthedocs.org";
        license = licenses.asl20;
        description = "A utility belt for advanced users of python-requests";
      };
    };



    "rsa" = python.mkDerivation {
      name = "rsa-3.4.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"; sha256 = "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://stuvel.eu/rsa";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Pure-Python RSA implementation";
      };
    };



    "s3transfer" = python.mkDerivation {
      name = "s3transfer-0.1.13";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz"; sha256 = "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."botocore"
      self."futures"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/s3transfer";
        license = licenses.asl20;
        description = "An Amazon S3 Transfer Manager";
      };
    };



    "sasl" = python.mkDerivation {
      name = "sasl-0.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8e/2c/45dae93d666aea8492678499e0999269b4e55f1829b1e4de5b8204706ad9/sasl-0.2.1.tar.gz"; sha256 = "04f22e17bbebe0cd42471757a48c2c07126773c38741b1dad8d9fe724c16289d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/toddlipcon/python-sasl";
        license = "";
        description = "Cyrus-SASL bindings for Python";
      };
    };



    "setproctitle" = python.mkDerivation {
      name = "setproctitle-1.1.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"; sha256 = "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/dvarrazzo/py-setproctitle";
        license = licenses.bsdOriginal;
        description = "A Python module to customize the process title";
      };
    };



    "singledispatch" = python.mkDerivation {
      name = "singledispatch-3.4.0.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"; sha256 = "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.python.org/3/library/functools.html#functools.singledispatch";
        license = licenses.mit;
        description = "This library brings functools.singledispatch from Python 3.4 to Python 2.6-3.3.";
      };
    };



    "six" = python.mkDerivation {
      name = "six-1.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"; sha256 = "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pypi.python.org/pypi/six/";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };



    "slackclient" = python.mkDerivation {
      name = "slackclient-1.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1f/9e/dd5bb327786be753e5d8de976082eb714cb83abeb00f67f0646ba2e166ad/slackclient-1.2.1.tar.gz"; sha256 = "e9de0c893e8c5473107f5927ae1e543d35246f0c834f5e86470b22b762211577"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."requests"
      self."six"
      self."websocket-client"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/slackapi/python-slackclient";
        license = licenses.mit;
        description = "Slack API clients for Web API and RTM API";
      };
    };



    "smmap2" = python.mkDerivation {
      name = "smmap2-2.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ad/e9/0fb974b182ff41d28ad267d0b4201b35159619eb610ea9a2e036817cb0b8/smmap2-2.0.4.tar.gz"; sha256 = "dc216005e529d57007ace27048eb336dcecb7fc413cfb3b2f402bb25972b69c6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gitpython-developers/smmap";
        license = licenses.bsdOriginal;
        description = "A pure python implementation of a sliding window memory map manager";
      };
    };



    "snakebite" = python.mkDerivation {
      name = "snakebite-2.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ed/44/d058b322004f7f0254e2848385dba8f180c3913bb833f16b5fffd784ef77/snakebite-2.11.0.tar.gz"; sha256 = "085238b4944cb9c658ee62d5794de936ac3d0c337c504b2cc86424a205ae978a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."argparse"
      self."protobuf"
      self."sasl"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/spotify/snakebite";
        license = licenses.asl20;
        description = "Pure Python HDFS client";
      };
    };



    "snowballstemmer" = python.mkDerivation {
      name = "snowballstemmer-1.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/20/6b/d2a7cb176d4d664d94a6debf52cd8dbae1f7203c8e42426daa077051d59c/snowballstemmer-1.2.1.tar.gz"; sha256 = "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/shibukawa/snowball_py";
        license = licenses.bsdOriginal;
        description = "This package provides 16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms.";
      };
    };



    "sphinx-argparse" = python.mkDerivation {
      name = "sphinx-argparse-0.2.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0f/f6/3294e3e07d74eb42ddc52815b71f94e07d7ab10ba27fa8b489fa76fcc2ce/sphinx-argparse-0.2.2.tar.gz"; sha256 = "a00666c5252b303a638c80c42384deba8a2d62dd980aad7de39d0f5dc7244952"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
      self."sphinx-rtd-theme"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ribozz/sphinx-argparse";
        license = licenses.mit;
        description = "A sphinx extension that automatically documents argparse commands and options";
      };
    };



    "sphinx-rtd-theme" = python.mkDerivation {
      name = "sphinx-rtd-theme-0.4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1c/f2/a1361e5f399e0b4182d031065eececa63ddb8c19a0616b03f119c4d5b6b4/sphinx_rtd_theme-0.4.0.tar.gz"; sha256 = "de88d637a60371d4f923e06b79c4ba260490c57d2ab5a8316942ab5d9a6ce1bf"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/rtfd/sphinx_rtd_theme/";
        license = licenses.mit;
        description = "Read the Docs theme for Sphinx";
      };
    };



    "sphinxcontrib-websupport" = python.mkDerivation {
      name = "sphinxcontrib-websupport-1.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/07/7a/e74b06dce85555ffee33e1d6b7381314169ebf7e31b62c18fcb2815626b7/sphinxcontrib-websupport-1.1.0.tar.gz"; sha256 = "9de47f375baf1ea07cdb3436ff39d7a9c76042c10a769c52353ec46e4e8fc3b9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."mock"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://sphinx-doc.org/";
        license = licenses.bsdOriginal;
        description = "Sphinx API for Web Apps";
      };
    };



    "tabulate" = python.mkDerivation {
      name = "tabulate-0.7.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"; sha256 = "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/astanin/python-tabulate";
        license = "Copyright (c) 2011-2016 Sergey Astanin";
        description = "Pretty-print tabular data";
      };
    };



    "termstyle" = python.mkDerivation {
      name = "termstyle-0.1.11";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/65/53/4dfdfe12b499f375cc78caca9cf146c01e752bab7713de4510d35e3da306/termstyle-0.1.11.tar.gz"; sha256 = "ef74b83698ea014112040cf32b1a093c1ab3d91c4dd18ecc03ec178fd99c9f9f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/gfxmonk/termstyle";
        license = licenses.bsdOriginal;
        description = "console colouring for python";
      };
    };



    "thrift" = python.mkDerivation {
      name = "thrift-0.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c6/b4/510617906f8e0c5660e7d96fbc5585113f83ad547a3989b80297ac72a74c/thrift-0.11.0.tar.gz"; sha256 = "7d59ac4fdcb2c58037ebd4a9da5f9a49e3e034bf75b3f26d9fe48ba3d8806e6b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."backports.ssl-match-hostname"
      self."ipaddress"
      self."six"
      self."tornado"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://thrift.apache.org";
        license = licenses.asl20;
        description = "Python bindings for the Apache Thrift RPC system";
      };
    };



    "thrift-sasl" = python.mkDerivation {
      name = "thrift-sasl-0.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/50/fe/89cbc910809e3757c762f56ee190ca39e0f28b7ea451835232c0c988d706/thrift_sasl-0.3.0.tar.gz"; sha256 = "80e015290e7c9afc5b4864bfb964e841d4d98e1d70f74bc216cf269f243f3362"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."sasl"
      self."thrift"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cloudera/thrift_sasl";
        license = licenses.asl20;
        description = "Thrift SASL Python module that implements SASL transports for Thrift (`TSaslClientTransport`).";
      };
    };



    "tornado" = python.mkDerivation {
      name = "tornado-5.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/45/ec/f2a03a0509bcfca336bef23a3dab0d07504893af34fd13064059ba4a0503/tornado-5.1.tar.gz"; sha256 = "4f66a2172cb947387193ca4c2c3e19131f1c70fa8be470ddbbd9317fd0801582"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."backports-abc"
      self."futures"
      self."singledispatch"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.tornadoweb.org/";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed.";
      };
    };



    "typing" = python.mkDerivation {
      name = "typing-3.6.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ec/cc/28444132a25c113149cec54618abc909596f0b272a74c55bab9593f8876c/typing-3.6.4.tar.gz"; sha256 = "d400a9344254803a2368533e4533a4200d21eb7b6b729c173bc38201a74db3f2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.python.org/3/library/typing.html";
        license = licenses.psfl;
        description = "Type Hints for Python";
      };
    };



    "unicodecsv" = python.mkDerivation {
      name = "unicodecsv-0.14.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"; sha256 = "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jdunck/python-unicodecsv";
        license = licenses.bsdOriginal;
        description = "Python2's stdlib csv module is nice, but it doesn't support unicode. This module is a drop-in replacement which *does*.";
      };
    };



    "uritemplate" = python.mkDerivation {
      name = "uritemplate-3.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"; sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uritemplate.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "URI templates";
      };
    };



    "urllib3" = python.mkDerivation {
      name = "urllib3-1.23";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"; sha256 = "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."cryptography"
      self."idna"
      self."ipaddress"
      self."pyOpenSSL"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };



    "vine" = python.mkDerivation {
      name = "vine-1.1.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/32/23/36284986e011f3c130d802c3c66abd8f1aef371eae110ddf80c5ae22e1ff/vine-1.1.4.tar.gz"; sha256 = "52116d59bc45392af9fdd3b75ed98ae48a93e822cee21e5fda249105c59a7a72"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/vine";
        license = licenses.bsdOriginal;
        description = "Promises, promises, promises.";
      };
    };



    "webencodings" = python.mkDerivation {
      name = "webencodings-0.5.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"; sha256 = "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/SimonSapin/python-webencodings";
        license = licenses.bsdOriginal;
        description = "Character encoding aliases for legacy web content";
      };
    };



    "websocket-client" = python.mkDerivation {
      name = "websocket-client-0.48.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/28/85/df04ec21c622728316b591c2852fd20a0e74324eeb6ca26f351844ba815f/websocket_client-0.48.0.tar.gz"; sha256 = "18f1170e6a1b5463986739d9fd45c4308b0d025c1b2f9b88788d8f69e8a5eb4a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/websocket-client/websocket-client.git";
        license = licenses.lgpl2;
        description = "WebSocket client for python. hybi13 is supported.";
      };
    };



    "xmltodict" = python.mkDerivation {
      name = "xmltodict-0.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1/xmltodict-0.11.0.tar.gz"; sha256 = "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/martinblech/xmltodict";
        license = licenses.mit;
        description = "Makes working with XML feel like you are working with JSON";
      };
    };



    "zope.deprecation" = python.mkDerivation {
      name = "zope.deprecation-4.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a1/18/2dc5e6bfe64fdc3b79411b67464c55bb0b43b127051a20f7f492ab767758/zope.deprecation-4.3.0.tar.gz"; sha256 = "7d52e134bbaaa0d72e1e2bc90f0587f1adc116c4bdf15912afaf2f1e8856b224"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Sphinx"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/zopefoundation/zope.deprecation";
        license = licenses.zpl21;
        description = "Zope Deprecation Infrastructure";
      };
    };

  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [

  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )
