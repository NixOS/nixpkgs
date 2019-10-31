{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, darwin
}:

with rustPlatform; 

buildRustPackage rec {
  version = "0.22.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "v${version}";
    sha256 = "12m95lfqwdxs2m5kjh3yrpm9w2li5m8n3fw46a2nkxyfw6c94l4b";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "1pwg35kgn5z2zrlj1dwcbbdmkgmnvfxpxv4klzsxxg4m9xr1pfy4";

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = https://github.com/mozilla/geckodriver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
