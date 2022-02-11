{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XFx8M9cQ7uXm4LS983FOZ6hz3zffLahhwrBjytbwEWk=";
  };

  cargoSha256 = "sha256-ngWvbNx41K3PfGbzJfH8uBUl0cuI/Abj6EbX8YANk6Q=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
