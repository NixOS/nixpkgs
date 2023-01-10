{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, fetchpatch
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+sSzYewqN3VjTl+wjgan3yxlFiuCg2rprJDpDktuQHo=";
  };

  cargoSha256 = "sha256-HhtslN6JV9DUBhuyesciZGGYVz7mvpdyxVps9xAc+Rs=";

  patches = [
    # https://github.com/libreddit/libreddit/pull/687
    (fetchpatch {
      name = "fix-cfg-test.patch";
      url = "https://github.com/libreddit/libreddit/commit/dff91da8777dc42d38abf8b5d63addbd71fdabff.patch";
      sha256 = "sha256-6np5gf8cyKotF7KJ19mCtRAF7SxDpNFpQCgdy/XDsng=";
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  passthru.tests = {
    inherit (nixosTests) libreddit;
  };

  meta = with lib; {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/libreddit/libreddit";
    changelog = "https://github.com/libreddit/libreddit/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab jojosch ];
  };
}
