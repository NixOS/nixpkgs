{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.18";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-J7K7fqtHNQYk6JlcHhcyojHQlIyaQVlAsDnfJUX1Ess=";
  };

  cargoHash = "sha256-a6ENeLG/t8Nb8oTNkcIWlquav4wJ0a3CqDEMQwTiuMM=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
