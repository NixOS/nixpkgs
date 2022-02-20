{ lib, fetchFromGitHub, fetchpatch, python3 }:
python3.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c+YP4pEGvLi7wZsDXrkoqR/isuYfXQmTwQp9gN5jHkQ=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt

    substituteInPlace setup.cfg \
      --replace "irc >=19.0.0, <20.0" "irc"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
