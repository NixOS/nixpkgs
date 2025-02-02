{ lib
, stdenv
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, makeWrapper
# Tie withPlugins through the fixed point here, so it will receive an
# overridden version properly
, buildbot
, pythonOlder
, python
, pythonRelaxDepsHook
, twisted
, jinja2
, msgpack
, zope-interface
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
}:

let
  withPlugins = plugins: buildPythonApplication {
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
  version = "3.11.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "buildbot";
    repo = "buildbot";
    rev = "v${version}";
    hash = "sha256-rDbAWLoEEjygW72YDBsVwiaHdRTVYA9IFxY3XMDleho=";
  };

  build-system = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "twisted"
  ];

  propagatedBuildInputs = [
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
    # Fix gitpoller, source: https://github.com/buildbot/buildbot/pull/7664
    # Included in next release.
    (fetchpatch {
      url = "https://github.com/buildbot/buildbot/commit/dd5d61e63e3b0740cc538a225ccf104ccecfc734.patch";
      sha256 = "sha256-CL6uRaKxh8uCBfWQ0tNiLh2Ym0HVatWni8hcuTyAAw0=";
      excludes = ["master/buildbot/test/unit/changes/test_gitpoller.py"];
    })
  ];

  postPatch = ''
    substituteInPlace master/buildbot/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
  '';
  preBuild = ''
    cd master
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
    description = "Open-source continuous integration framework for automating software build, test, and release processes";
    homepage = "https://buildbot.net/";
    changelog = "https://github.com/buildbot/buildbot/releases/tag/v${version}";
    maintainers = teams.buildbot.members;
    license = licenses.gpl2Only;
    broken = stdenv.isDarwin;
  };
}
