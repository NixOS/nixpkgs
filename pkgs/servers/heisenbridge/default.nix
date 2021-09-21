{ lib, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "1.1.1";

  # Use the release tarball because it has the version set correctly using the
  # version.txt file.
  src = fetchurl {
    url = "https://github.com/hifi/heisenbridge/releases/download/v${version}/heisenbridge-v${version}.tar.gz";
    sha256 = "sha256-thI3NYYnLHmlfs5mmH2SQcREBLWtnilYlxriKWnamPM=";
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
