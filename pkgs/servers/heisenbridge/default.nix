{ lib, fetchFromGitHub, fetchpatch, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q1Rj8BehvYnV/Kah5YKAxBUz4j9WziSqn1fVeaKpy7g=";
  };

  patches = [
    # Compatibility with aiohttp 3.8.0
    (fetchpatch {
      url = "https://github.com/hifi/heisenbridge/commit/cff5d33e0b617e6cf3a44dc00c72b98743175c9e.patch";
      sha256 = "sha256-y5X4mWvX1bq0XNZNTYUc0iK3SzvaHpS7px53I7xC9c8=";
    })
  ];

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
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
