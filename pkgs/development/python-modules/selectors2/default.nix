{ stdenv, buildPythonPackage, fetchPypi
, nose, psutil, mock }:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "selectors2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81b77c4c6f607248b1d6bbdb5935403fef294b224b842a830bbfabb400c81884";
  };

  checkInputs = [ nose psutil mock ];

  checkPhase = ''
    # https://github.com/NixOS/nixpkgs/pull/46186#issuecomment-419450064
    # Trick to disable certain tests that depend on timing which
    # will always fail on hydra
    export TRAVIS=""
    nosetests tests/test_selectors2.py
  '';

  meta = with stdenv.lib; {
    homepage = https://www.github.com/SethMichaelLarson/selectors2;
    description = "Back-ported, durable, and portable selectors";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
