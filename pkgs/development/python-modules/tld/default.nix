{ stdenv, fetchPypi, python }:

python.pkgs.buildPythonPackage rec {
  pname   = "tld";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i0prgwrmm157h6fa5bx9wm0m70qq2nhzp743374a94p9s766rpp";
  };

  propagatedBuildInputs = with python.pkgs; [ six ];
  checkInputs = with python.pkgs; [ factory_boy faker pytest pytestcov tox ];

  # https://github.com/barseghyanartur/tld/issues/54
  disabledTests = stdenv.lib.concatMapStringsSep " and " (s: "not " + s) ([
    "test_1_update_tld_names"
    "test_1_update_tld_names_command"
    "test_2_update_tld_names_module"
  ]);

  checkPhase = ''
      export PATH="$PATH:$out/bin"
      py.test -k '${disabledTests}'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/barseghyanartur/tld;
    description = "Extracts the top level domain (TLD) from the URL given";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ genesis ];
  };

}
