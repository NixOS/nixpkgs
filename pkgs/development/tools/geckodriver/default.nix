{ lib
, fetchzip
, rustPlatform
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  version = "0.26.0";
  pname = "geckodriver";
  sourceRoot = "source/testing/geckodriver";

  # Source revisions are noted alongside the binary releases:
  # https://github.com/mozilla/geckodriver/releases
  src = (fetchzip {
    url = "https://hg.mozilla.org/mozilla-central/archive/e9783a644016aa9b317887076618425586730d73.zip/testing";
    sha256 = "0m86hqyq1jrr49jkc8mnlmx4bdq281hyxhcrrzacyv20nlqwvd8v";
  }).overrideAttrs (_: {
    # normally guessed by the url's file extension, force it to unpack properly
    unpackCmd = "unzip $curSrc";
  });

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "07w5lmvm5w6id0qikcs968n0c69bb6fav63l66bskxcjva67d6dy";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = https://github.com/mozilla/geckodriver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
