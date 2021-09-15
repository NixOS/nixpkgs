{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyserial-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2021.9.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = pname;
    rev = version;
    sha256 = "0q7jrjljp65lrazv2yjsiw69240vmhcss3dqrgxhq79dpyck6zfl";
  };

  propagatedBuildInputs = [
    pyserial-asyncio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ " velbusaio" ];

  meta = with lib; {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
