{ lib, stdenv, buildPythonPackage, fetchPypi, python, coverage, lsof, glibcLocales, coreutils, pytestCheckHook }:

buildPythonPackage rec {
  pname = "sh";
  version = "1.14.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5ARbbHMtnOddVxx59awiNO3Zrk9fqdWbCXBQgr3KGMc=";
  };

  postPatch = ''
    sed -i 's#/usr/bin/env python#${python.interpreter}#' test.py
    sed -i 's#/bin/sleep#${coreutils.outPath}/bin/sleep#' test.py
  '';

  nativeCheckInputs = [ coverage lsof glibcLocales pytestCheckHook ];

  # A test needs the HOME directory to be different from $TMPDIR.
  preCheck = ''
    export LC_ALL="en_US.UTF-8"
    HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [ "test.py" ];

  disabledTests = [
    # Disable tests that fail on Hydra
    "test_no_fd_leak"
    "test_piped_exception1"
    "test_piped_exception2"
    "test_unicode_path"
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable tests that fail on Darwin sandbox
    "test_background_exception"
    "test_cwd"
    "test_ok_code"
  ];

  meta = with lib; {
    description = "Python subprocess interface";
    homepage = "https://pypi.python.org/pypi/sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
