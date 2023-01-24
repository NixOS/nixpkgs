{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.8";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ROMO6IkfpzFvB5Y4RRqrX5NnYzdHT1tsJBdCc1lDu7k=";
  };

  cargoHash = "sha256-VAVlzciWVKcgl/QKiF3Hfzx11jUi/0J9b6EmaZzG9qE=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
