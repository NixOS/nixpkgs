{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "book-summary";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dvogt23";
    repo = pname;
    rev = version;
    sha256 = "1dawddkpyasy22biqz35c912xqmwcx6ihpqp6cnikbdzv8ni8adr";
  };

  cargoPatches = [
    # add Cargo.lock
    # can be removed after https://github.com/dvogt23/book-summary/pull/23 gets merged
    (fetchpatch {
      url = "https://github.com/dvogt23/book-summary/commit/9d941a57db5cd2fd0e9813230d69eb1d166a48f8.patch";
      sha256 = "sha256-91dwJKdaLukxVZHA3RH1rxj45U/+mabFTflBaLd2rK8=";
    })
  ];

  cargoSha256 = "sha256-chuEzYUfZC/ZdWIUEmAXJAnXG2s8mCcNs6cuq8Lh5PQ=";

  meta = with lib; {
    description = "Book auto-summary for gitbook and mdBook";
    homepage = "https://github.com/dvogt23/book-summary";
    license = licenses.mit;
    maintainers = with teams; iog.members;
  };
}
