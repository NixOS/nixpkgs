{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q7xqKjAUBHh87VAgsgDOCPDINDh0yUdr3UoUlLqJr5k=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt

    substituteInPlace setup.cfg \
      --replace "mautrix >=0.10.5, <0.11" "mautrix >=0.10.5, <0.12"
  '';

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
