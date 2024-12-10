{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # Upstream forgot to bump the version in Cargo.lock in 0.3.5
    # TODO use git tag again on next release
    # https://github.com/google/mdbook-i18n-helpers/pull/216#issuecomment-2255799969
    rev = "d80451f48af3f495ad78512865cbe5943928b96c";
    hash = "sha256-JMVxSNhMLMfsP+cJkuRUWknZZM7Ji0RjbLqrgjHeg6g=";
  };

  cargoHash = "sha256-Fru3Rwsu9siqkgpGcM1ubs49jvhQkEnmH9/+kPbmayM=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      teutat3s
      matthiasbeyer
    ];
  };
}
