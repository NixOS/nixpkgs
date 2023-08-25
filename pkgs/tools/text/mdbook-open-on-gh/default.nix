{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-d+8/7lli6iyzAWHIi0ahwPBwGhXrQrCKQisD2+jPHQ0=";
  };

  cargoHash = "sha256-WbPYrjDMJEwle+Pev5nr9ZhnycbXUjdrx8XAqQ0OpaM=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
