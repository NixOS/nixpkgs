{ borgbackup, coreutils, lib, python3Packages, systemd }:

python3Packages.buildPythonApplication rec {
  pname = "borgmatic";
  version = "1.5.12";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-XLbBJvNRmH8W9SnOjF7zUbazRYFCMW6SEO2wKN/2VTY=";
  };

  checkInputs = with python3Packages; [ flexmock pytestCheckHook pytest-cov ];

  # - test_borgmatic_version_matches_news_version
  # The file NEWS not available on the pypi source, and this test is useless
  # - test_collect_configuration_run_summary_logs_outputs_merged_json_results
  # Upstream fixed in the next version, see
  # https://github.com/witten/borgmatic/commit/ea6cd53067435365a96786b006aec391714501c4
  disabledTests = [
    "test_borgmatic_version_matches_news_version"
    "test_collect_configuration_run_summary_logs_outputs_merged_json_results"
  ];

  propagatedBuildInputs = with python3Packages; [
    borgbackup
    colorama
    pykwalify
    ruamel_yaml
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
