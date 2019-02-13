{ stdenv, fetchpatch, openssh, buildbot-worker, buildbot-pkg, pythonPackages, runCommand, makeWrapper }:

let
  withPlugins = plugins: runCommand "wrapped-${package.name}" {
    buildInputs = [ makeWrapper ] ++ plugins;
    propagatedBuildInputs = package.propagatedBuildInputs;
    passthru.withPlugins = moarPlugins: withPlugins (moarPlugins ++ plugins);
  } ''
    makeWrapper ${package}/bin/buildbot $out/bin/buildbot \
      --prefix PYTHONPATH : "${package}/lib/python2.7/site-packages:$PYTHONPATH"
    ln -sfv ${package}/lib $out/lib
  '';

  package = pythonPackages.buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "buildbot";
    version = "1.2.0";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "02gwmls8kgm6scy36hdy0bg645zs1pxlrgwkcn79wrl7cfmabcbv";
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
      buildbot-pkg
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

      # CVE-2019-7313
      # https://github.com/buildbot/buildbot/wiki/CRLF-injection-in-Buildbot-login-and-logout-redirect-code
      # https://github.com/buildbot/buildbot/compare/v1.8.0...v1.8.1
      (fetchpatch {
        url = "https://github.com/buildbot/buildbot/commit/bdae9fea4e8978b19e12425776b2d083febd91a6.diff";
        sha256 = "18fbcbqphs8jjmfvjjcbcnv5wj87mj6jv9lmx17lfhpi5hg2axph";
        stripLen = 1;
      })
    ];

    # TimeoutErrors on slow machines -> aarch64
    doCheck = !stdenv.isAarch64;

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
  };
in package
