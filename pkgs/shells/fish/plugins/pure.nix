{ lib, buildFishPlugin, fetchFromGitHub, git, fishtape }:

buildFishPlugin rec {
  pname = "pure";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "rafaelrinaldi";
    repo = "pure";
    rev = "v${version}";
    sha256 = "134sz3f98gb6z2vgd5kkm6dd8pka5gijk843c32s616w35y07sga";
  };

  checkInputs = [ git ];
  checkFunctionPath = [ fishtape ];
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
