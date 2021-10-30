{ lib, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "1.4.0";

  # Use the release tarball because it has the version set correctly using the
  # version.txt file.
  src = fetchurl {
    url = "https://github.com/hifi/heisenbridge/releases/download/v${version}/heisenbridge-${version}.tar.gz";
    sha256 = "sha256-Br+7ykTtVYC7KIhikmgS9wbQdJFHFezlVre8cUBzAx8=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
