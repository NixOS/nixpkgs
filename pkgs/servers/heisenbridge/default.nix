{ lib, fetchFromGitHub, fetchpatch, python3 }:
python3.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-3YCYLhJqZAWIwpwOd8J1+uYsxw0q6jQy35Vp+ttVKhI=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
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
