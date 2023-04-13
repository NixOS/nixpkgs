{ lib, buildFishPlugin, fetchFromGitHub, git, fishtape }:

buildFishPlugin rec {
  pname = "pure";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "pure-fish";
    repo = "pure";
    rev = "v${version}";
    sha256 = "1x1h65l8582p7h7w5986sc9vfd7b88a7hsi68dbikm090gz8nlxx";
  };

  # The tests aren't passing either on the project's CI.
  # The release notes of the program for v3.5.0 say:
  # > Tests are going crazy at the moment, should be fixed once fishtape 3.0
  # > is released, and we do the switch.
  # This is tracked in https://github.com/pure-fish/pure/issues/272
  # and https://github.com/pure-fish/pure/pull/275.
  doCheck = false;

  nativeCheckInputs = [ git ];
  checkPlugins = [ fishtape ];
  checkPhase = ''
    # https://github.com/rafaelrinaldi/pure/issues/264
    rm tests/_pure_string_width.test.fish

    fishtape tests/*.test.fish
  '';

  meta = {
    description = "Pretty, minimal and fast Fish prompt, ported from zsh";
    homepage = "https://github.com/rafaelrinaldi/pure";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pacien ];
  };
}
