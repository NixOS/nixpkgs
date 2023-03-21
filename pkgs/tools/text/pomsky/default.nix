{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pomsky";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "pomsky-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V4WztquClcBQF74c8WalWITT+SRymEawLXmvTflNEGk=";
  };

  cargoHash = "sha256-34lI4zI1JMYek3sCXOWw08EqhaI1bqTGFPxeEYmEbXQ=";

  # thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: invalid option '--test-threads''
  doCheck = false;

  meta = with lib; {
    description = "A portable, modern regular expression language";
    homepage = "https://pomsky-lang.org";
    changelog = "https://github.com/pomsky-lang/pomsky/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
