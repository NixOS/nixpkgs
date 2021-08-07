{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "spikecodes";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f5xla6fgq4l9g95gwwvfxksaxj4zpayrsjacf53akjpxaqvqxdj";
  };

  cargoSha256 = "039k6kncdgy6q2lbcssj5dm9npk0yss5m081ps4nmdj2vjrkphf0";

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoPatches = [
    # Patch file to add/update Cargo.lock in the source code
    # https://github.com/spikecodes/libreddit/issues/191
    ./add-Cargo.lock.patch
  ];

  passthru.tests = {
    inherit (nixosTests) libreddit;
  };

  meta = with lib; {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/spikecodes/libreddit";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
