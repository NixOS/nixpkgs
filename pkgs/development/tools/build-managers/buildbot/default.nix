{ stdenv, lib, openssh, buildbot-worker, pythonPackages, runCommand, makeWrapper }:

let
  withPlugins = plugins: runCommand "wrapped-${package.name}" {
    buildInputs = [ makeWrapper ];
    passthru.withPlugins = moarPlugins: withPlugins (moarPlugins ++ plugins);
  } ''
    makeWrapper ${package}/bin/buildbot $out/bin/buildbot \
      --prefix PYTHONPATH : ${lib.makeSearchPathOutput "lib" pythonPackages.python.sitePackages plugins}
  '';

  package = pythonPackages.buildPythonApplication (rec {
    name = "${pname}-${version}";
    pname = "buildbot";
    version = "0.9.4";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0wklrn4fszac9wi8zw3vbsznwyff6y57cz0i81zvh46skb6n3086";
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
