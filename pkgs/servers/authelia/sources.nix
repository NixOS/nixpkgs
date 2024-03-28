{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.6";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-TW+BRm12nZ6k9JHImY1e8gg6RjSLldjHqJNrZjtnofo=";
  };
  vendorHash = "sha256-7hoFVAMf2Lqit+XKmDxJ8ZkWIdBq61h5x1DESPiAJ1I=";
  npmDepsHash = "sha256-lDkZ4Tjx3jstuMLCXzZ2R0AO9dRv2jTwS7jzlJEv6tk=";
}
