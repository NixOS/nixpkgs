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
    version = "0.9.9.post2";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0g932pvkxqq3ijwkwwa29jd9sp5895gv40c3k7m2acc5dp8ygb9w";
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
      # This patch disables the test that tries to read /etc/os-release which
      # is not accessible in sandboxed builds.
      ./skip_test_linux_distro.patch
    ];

    postPatch = ''
      substituteInPlace buildbot/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
    '';

    passthru = { inherit withPlugins; };

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot is an open-source continuous integration framework for automating software build, test, and release processes";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  });
in package
