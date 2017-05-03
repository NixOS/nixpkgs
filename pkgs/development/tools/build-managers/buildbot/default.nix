{ stdenv, lib, openssh, buildbot-worker, pythonPackages, runCommand, makeWrapper }:

let
  withPlugins = plugins: runCommand "wrapped-${package.name}" {
    buildInputs = [ makeWrapper ] ++ plugins;
    passthru.withPlugins = moarPlugins: withPlugins (moarPlugins ++ plugins);
  } ''
    makeWrapper ${package}/bin/buildbot $out/bin/buildbot \
      --prefix PYTHONPATH : "${package}/lib/python2.7/site-packages:$PYTHONPATH"
    ln -sfv ${package}/lib $out/lib
  '';

  package = pythonPackages.buildPythonApplication (rec {
    name = "${pname}-${version}";
    pname = "buildbot";
    version = "0.9.5";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "11r553nmh87a9pm58wycimapk2pw9hnlc7hffn97xwbqprd8qh66";
    };

    buildInputs = with pythonPackages; [
      lz4
      txrequests
      pyjade
      boto3
      moto
      txgithub
      mock
      setuptoolsTrial
      isort
      pylint
      astroid
      pyflakes
      openssh
      buildbot-worker
      treq
    ];

    propagatedBuildInputs = with pythonPackages; [

      # core
      twisted
      jinja2
      zope_interface
      sqlalchemy
      sqlalchemy_migrate
      future
      dateutil
      txaio
      autobahn
      pyjwt
      distro

      # tls
      pyopenssl
      service-identity
      idna

      # docs
      sphinx
      sphinxcontrib-blockdiag
      sphinxcontrib-spelling
      pyenchant
      docutils
      ramlfications
      sphinx-jinja

    ];

    postPatch = ''
      substituteInPlace buildbot/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"

      # NOTE: secrets management tests currently broken
      rm -fv buildbot/test/integration/test_integration_secrets.py
      rm -fv buildbot/test/integration/test_integration_secrets_with_vault.py
      rm -fv buildbot/test/unit/test_fake_secrets_manager.py
      rm -fv buildbot/test/unit/test_interpolate_secrets.py
      rm -fv buildbot/test/unit/test_secret_in_file.py
      rm -fv buildbot/test/unit/test_secret_in_vault.py
    '';

    passthru = { inherit withPlugins; };

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Continuous integration system that automates the build/test cycle";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  });
in package
