{ lib
, fetchzip
, rustPlatform
, stdenv
, darwin
, libiconv
}:

rustPlatform.buildRustPackage {
  version = "0.29.1";
  pname = "geckodriver";
  sourceRoot = "source/testing/geckodriver";

  # Source revisions are noted alongside the binary releases:
  # https://github.com/mozilla/geckodriver/releases
  src = (fetchzip {
    url = "https://hg.mozilla.org/mozilla-central/archive/970ef713fe58cbc8a29bfb2fb452a57e010bdb08.zip/testing";
    sha256 = "0cpx0kx8asqkmz2nyanbmcvhnrsksgd6jp3wlcd0maid3qbyw7s2";
  }).overrideAttrs (_: {
    # normally guessed by the url's file extension, force it to unpack properly
    unpackCmd = "unzip $curSrc";
  });

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1fxm4jgg95igqadi97dzhrw7bhi5hfh7ww81c3z4yk0lznbzv6mx";

  buildInputs = [ libiconv ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
