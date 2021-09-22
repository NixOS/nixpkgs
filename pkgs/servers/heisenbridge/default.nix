{ lib, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "1.1.2";

  # Use the release tarball because it has the version set correctly using the
  # version.txt file.
  src = fetchurl {
    url = "https://github.com/hifi/heisenbridge/releases/download/v${version}/heisenbridge-${version}.tar.gz";
    sha256 = "sha256-hY0dB4QT9W18ubUytvJwRUWKpNQMpyYdSLbmu+c8BCo=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    pyyaml
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
