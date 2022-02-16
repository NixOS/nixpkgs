{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dQ+FLKf+zNrUabrXWvdYqpNXzS+j92zQcaZXPTxxB/E=";
  };

  cargoSha256 = "sha256-ud2Hb8EoOiPyzp7qPUeQi8FZ49RXbrDsk8ZEBI6lPtk=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
