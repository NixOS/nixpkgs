{ lib
, stdenv
, buildPythonPackage
, buildPythonApplication
, fetchPypi
, makeWrapper
, pythonOlder
, python
, twisted
, jinja2
, msgpack
, zope_interface
, sqlalchemy
, alembic
, python-dateutil
, txaio
, autobahn
, pyjwt
, pyyaml
, treq
, txrequests
, pypugjs
, boto3
, moto
, markdown
, lz4
, setuptools-trial
, buildbot-worker
, buildbot-plugins
, buildbot-pkg
, parameterized
, git
, openssh
, setuptools
, croniter
, importlib-resources
, packaging
, unidiff
, glibcLocales
, nixosTests
, callPackage
}:

let
  withPlugins = plugins: buildPythonApplication {
    pname = "${package.pname}-with-plugins";
    inherit (package) version;
    format = "other";

    dontUnpack = true;
    dontBuild = true;
    doCheck = false;

    nativeBuildInputs = [
      makeWrapper
    ];

    propagatedBuildInputs = plugins ++ package.propagatedBuildInputs;

    installPhase = ''
      makeWrapper ${package}/bin/buildbot $out/bin/buildbot \
        --prefix PYTHONPATH : "${package}/${python.sitePackages}:$PYTHONPATH"
      ln -sfv ${package}/lib $out/lib
    '';

    passthru = package.passthru // {
      withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
    };
  };

  package = buildPythonApplication rec {
    pname = "buildbot";
    version = "3.10.1";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-/J4jWoIZEObSZKw04Ib6h4AvJtfNwzwozRu+gFek1Dk=";
    };

    propagatedBuildInputs = [
      # core
      twisted
      jinja2
      msgpack
      zope_interface
      sqlalchemy
      alembic
      python-dateutil
      txaio
      autobahn
      pyjwt
      pyyaml
      setuptools
      croniter
      importlib-resources
      packaging
      unidiff
    ]
      # tls
      ++ twisted.optional-dependencies.tls;

    nativeCheckInputs = [
      treq
      txrequests
      pypugjs
      boto3
      moto
      markdown
      lz4
      setuptools-trial
      buildbot-worker
      buildbot-pkg
      buildbot-plugins.www
      parameterized
      git
      openssh
      glibcLocales
    ];

    patches = [
      # This patch disables the test that tries to read /etc/os-release which
      # is not accessible in sandboxed builds.
      ./skip_test_linux_distro.patch
    ];

    postPatch = ''
      substituteInPlace buildbot/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
    '';

    # Silence the depreciation warning from SqlAlchemy
    SQLALCHEMY_SILENCE_UBER_WARNING = 1;

    # TimeoutErrors on slow machines -> aarch64
    doCheck = !stdenv.isAarch64;

    preCheck = ''
      export LC_ALL="en_US.UTF-8"
      export PATH="$out/bin:$PATH"

      # remove testfile which is missing configuration file from sdist
      rm buildbot/test/integration/test_graphql.py
      # tests in this file are flaky, see https://github.com/buildbot/buildbot/issues/6776
      rm buildbot/test/integration/test_try_client.py
    '';

    passthru = {
      inherit withPlugins;
      tests.buildbot = nixosTests.buildbot;
      updateScript = ./update.sh;
    };

    meta = with lib; {
      description = "An open-source continuous integration framework for automating software build, test, and release processes";
      homepage = "https://buildbot.net/";
      changelog = "https://github.com/buildbot/buildbot/releases/tag/v${version}";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2Only;
      broken = stdenv.isDarwin;
    };
  };
in package
