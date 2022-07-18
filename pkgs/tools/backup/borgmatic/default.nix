{ borgbackup, coreutils, lib, python3Packages, systemd }:

python3Packages.buildPythonApplication rec {
  pname = "borgmatic";
  version = "1.6.4";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-2kQ+KO69RxpIQkrkD6n7l9ti9ITwdpHYK7LuXYUo3ck=";
  };

  checkInputs = with python3Packages; [ flexmock pytestCheckHook pytest-cov ];

  # - test_borgmatic_version_matches_news_version
  # The file NEWS not available on the pypi source, and this test is useless
  disabledTests = [
    "test_borgmatic_version_matches_news_version"
  ];

  propagatedBuildInputs = with python3Packages; [
    borgbackup
    colorama
    jsonschema
    ruamel-yaml
    requests
    setuptools
  ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    cp sample/systemd/borgmatic.timer $out/lib/systemd/system/
    substitute sample/systemd/borgmatic.service \
               $out/lib/systemd/system/borgmatic.service \
               --replace /root/.local/bin/borgmatic $out/bin/borgmatic \
               --replace systemd-inhibit ${systemd}/bin/systemd-inhibit \
               --replace sleep ${coreutils}/bin/sleep
  '';

  meta = with lib; {
    description = "Simple, configuration-driven backup software for servers and workstations";
    homepage = "https://torsion.org/borgmatic/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ imlonghao ];
  };
}
