{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, darwin
}:

with rustPlatform; 

buildRustPackage rec {
  version = "0.22.0";
  name = "geckodriver-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "v${version}";
    sha256 = "12m95lfqwdxs2m5kjh3yrpm9w2li5m8n3fw46a2nkxyfw6c94l4b";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "1a8idl6falz0n9irh1p8hv5w2pmiknzsfnxl70k1psnznrpk2y8n";

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = https://github.com/mozilla/geckodriver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
