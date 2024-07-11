{
  borgbackup,
  borgmatic,
  coreutils,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  fetchPypi,
  fetchpatch,
  installShellFiles,
  lib,
  python3Packages,
  stdenv,
  systemd,
  testers,
}:
python3Packages.buildPythonApplication rec {
  pname = "borgmatic";
  version = "1.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4Z5imxNjfvd4fkpFsggSO9XueN5Yzcz4RCl+BqmddCM=";
  };

  nativeCheckInputs = with python3Packages; [ flexmock pytestCheckHook pytest-cov ] ++ passthru.optional-dependencies.apprise;

  # - test_borgmatic_version_matches_news_version
  # The file NEWS not available on the pypi source, and this test is useless
  disabledTests = [
    "test_borgmatic_version_matches_news_version"
  ];

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with python3Packages; [
    borgbackup
    colorama
    jsonschema
    packaging
    requests
    ruamel-yaml
    setuptools
  ];

  passthru.optional-dependencies = {
    apprise = [ python3Packages.apprise ];
  };

  postInstall = ''
    installShellCompletion --cmd borgmatic \
      --bash <($out/bin/borgmatic --bash-completion)
  '' + lib.optionalString enableSystemd ''
    mkdir -p $out/lib/systemd/system
    cp sample/systemd/borgmatic.timer $out/lib/systemd/system/
    # there is another "sleep", so choose the one with the space after it
    # due to https://github.com/borgmatic-collective/borgmatic/commit/2e9f70d49647d47fb4ca05f428c592b0e4319544
    substitute sample/systemd/borgmatic.service \
               $out/lib/systemd/system/borgmatic.service \
               --replace /root/.local/bin/borgmatic $out/bin/borgmatic \
               --replace systemd-inhibit ${systemd}/bin/systemd-inhibit \
               --replace "sleep " "${coreutils}/bin/sleep "
  '';

  passthru.tests.version = testers.testVersion { package = borgmatic; };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple, configuration-driven backup software for servers and workstations";
    homepage = "https://torsion.org/borgmatic/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ imlonghao x123 ];
  };
}
