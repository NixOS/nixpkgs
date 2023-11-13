{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-readme";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "livioribeiro";
    repo = pname;
    # Git tag is missing, see upstream issue:
    # https://github.com/livioribeiro/cargo-readme/issues/61
    rev = "cf66017c0120ae198210ebaf58a0be6a78372974";
    sha256 = "sha256-/ufHHM13L83M3UYi6mjdhIjgXx7bZgzvR/X02Zsx7Fw=";
  };

  cargoSha256 = "sha256-Isd05qOuVBNfXOI5qsaDOhjF7QIKAG5xrZsBFK2PpQQ=";

  patches = [
    (fetchpatch {
      # Fixup warning thrown at build when running test-suite
      # unused return, see upstream PR:
      # https://github.com/livioribeiro/cargo-readme/pull/62
      url = "https://github.com/livioribeiro/cargo-readme/commit/060f2daaa2b2cf981bf490dc36bcc6527545ea03.patch";
      sha256 = "sha256-wlAIgTI9OqtA/Jnswoqp7iOj+1zjrUZA7JpHUiF/n+s=";
    })
  ];

  meta = with lib; {
    description = "Generate README.md from docstrings";
    homepage = "https://github.com/livioribeiro/cargo-readme";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ baloo matthiasbeyer ];
  };
}
