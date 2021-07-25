{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "0.99.1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    rev = "v${version}";
    sha256 = "sha256-v3ji450YFxMiyBOb4DuDJDvAGKhWYSSQ8kBB51r97PE=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    pyyaml
  ];

  checkInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
