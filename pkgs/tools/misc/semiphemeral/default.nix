{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "semiphemeral";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c90d73b14c826f262b1339d1f5926c5abc6431181090ea87177af821c0866fb7";
  };

  doCheck = false; # upstream has no tests

  pythonImportsCheck = [ "semiphemeral" ];

  propagatedBuildInputs = with python3.pkgs; [ click sqlalchemy flask tweepy colorama ];

  meta = with lib; {
    description = "Automatically delete your old tweets, except for the ones you want to keep";
    homepage = "https://github.com/micahflee/semiphemeral";
    license = licenses.mit;
    maintainers = with maintainers; [ amanjeev ];
    mainProgram = "semiphemeral";
  };
}
