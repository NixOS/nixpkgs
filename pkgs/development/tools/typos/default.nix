{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.9";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dAe19D9q5JXeWCnsfbz0NnAtnAQj0dyIy6cdyjqVxEg=";
  };

  cargoHash = "sha256-gc3tDTsmgvMfLbWh5XALEpZuK6e8FXsomfq4U/xTPXM=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
