{
  lib,
  stdenv,
  buildPythonApplication,
  fetchPypi,
  makeWrapper,
  # Tie withPlugins through the fixed point here, so it will receive an
  # overridden version properly
  buildbot,
  pythonOlder,
  python,
  pythonRelaxDepsHook,
  twisted,
  jinja2,
  msgpack,
  zope-interface,
  sqlalchemy,
  alembic,
  python-dateutil,
  txaio,
  autobahn,
  pyjwt,
  pyyaml,
  treq,
  txrequests,
  pypugjs,
  boto3,
  moto,
  markdown,
  lz4,
  setuptools-trial,
  buildbot-worker,
  buildbot-plugins,
  buildbot-pkg,
  parameterized,
  git,
  openssh,
  setuptools,
  croniter,
  importlib-resources,
  packaging,
  unidiff,
  glibcLocales,
  nixosTests,
}:

let
  withPlugins =
    plugins:
    buildPythonApplication {
      pname = "${buildbot.pname}-with-plugins";
      inherit (buildbot) version;
      format = "other";

      dontUnpack = true;
      dontBuild = true;
      doCheck = false;

      nativeBuildInputs = [
        makeWrapper
      ];

      propagatedBuildInputs = plugins ++ buildbot.propagatedBuildInputs;

      installPhase = ''
        makeWrapper ${buildbot}/bin/buildbot $out/bin/buildbot \
          --prefix PYTHONPATH : "${buildbot}/${python.sitePackages}:$PYTHONPATH"
        ln -sfv ${buildbot}/lib $out/lib
      '';

      passthru = buildbot.passthru // {
        withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
      };
    };
in
buildPythonApplication rec {
  pname = "buildbot";
  version = "3.11.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x7RaApfIe1x7Py1KLQCcotxU6dJRXTOk67W+QOhNJf0=";
  };

  build-system = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "twisted"
  ];

  propagatedBuildInputs =
    [
      # core
      twisted
      jinja2
      msgpack
      zope-interface
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
    maintainers = teams.buildbot.members;
    license = licenses.gpl2Only;
    broken = stdenv.isDarwin;
  };
}
