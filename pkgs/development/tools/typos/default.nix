{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:10ydsp77v4kf1qsq5wyc02iyfsdy0rpcyxycp2lqz9qy3g3ih7vm";
  };

  cargoSha256 = "sha256:1i6999nmg4pahpp4fz4qm4rx8iixa13zjwlhyixwjwbag1w8l3gp";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://https://github.com/crate-ci/typos/";
    license = [ licenses.asl20 licenses.mit ]; # dual licensed
    maintainers = [ maintainers.mgttlinger ];
  };
}
