{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
}:

buildPythonPackage rec {
  pname = "xmlunittest";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Exirel";
    repo = "python-xmlunittest";
    rev = version;
    hash = "sha256-aTLtzYlIX9wroMQN64V6S1sNeo8ZvkKX5r8b46xjN/U=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  meta = with lib; {
    description = "Library using lxml and unittest for unit testing XML";
    homepage = "https://github.com/Exirel/python-xmlunittest";
    changelog = "https://github.com/Exirel/python-xmlunittest/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
