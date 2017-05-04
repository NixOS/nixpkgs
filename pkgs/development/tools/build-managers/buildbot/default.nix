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
    version = "0.9.6";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0d6ys1wjwsv4jg4bja1cqhy279hhrl1c9kwyx126srf45slcvg1w";
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

    patches = [
      # This patch disables the test that tries to reat /etc/os-release which
      # is not accessible in sandboxed builds.
      ./skip_test_linux_distro.patch
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

      # Remove this line after next update. See
      # https://github.com/buildbot/buildbot/commit/e7fc8c8eba903c2aa6d7e6393499e5b9bffc2334
      rm -fv buildbot/test/unit/test_mq_wamp.py
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
