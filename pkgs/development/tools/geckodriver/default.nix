{ lib
, fetchzip
, rustPlatform
, stdenv
, Security
, libiconv
}:

rustPlatform.buildRustPackage {
  version = "0.30.0";
  pname = "geckodriver";
  sourceRoot = "source/testing/geckodriver";

  # Source revisions are noted alongside the binary releases:
  # https://github.com/mozilla/geckodriver/releases
  src = (fetchzip {
    url = "https://hg.mozilla.org/mozilla-central/archive/d372710b98a6ce5d1b2a9dffd53a879091c5c148.zip/testing";
    sha256 = "0d27h9c8vw4rs9c2l9wms4lc931nbp2g5hacsh24zhc9y3v454i6";
  }).overrideAttrs (_: {
    # normally guessed by the url's file extension, force it to unpack properly
    unpackCmd = "unzip $curSrc";
  });

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "08zcrhrmxh3c3iwd7kbnr19lfisikb779i2r7ir7b1i1ynmi4v6r";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
