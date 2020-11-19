{ stdenv, buildPythonPackage, fetchPypi
, nose, psutil, mock }:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "selectors2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f1bbaac203a23fbc851dc1b5a6e92c50698cc8cefa5873eb5b89eef53d1d82b";
  };

  checkInputs = [ nose psutil mock ];

  checkPhase = ''
    # https://github.com/NixOS/nixpkgs/pull/46186#issuecomment-419450064
    # Trick to disable certain tests that depend on timing which
    # will always fail on hydra
    export TRAVIS=""
    nosetests tests/test_selectors2.py \
      --exclude=test_above_fd_setsize
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.github.com/SethMichaelLarson/selectors2";
    description = "Back-ported, durable, and portable selectors";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
