{ lib
, fetchFromGitHub
, rustPlatform
}:

with rustPlatform; 

buildRustPackage rec {
  version = "unstable-2018-02-24";
  name = "geckodriver-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "gecko-dev";
    rev = "ecb86060b4c5a9808798b81a57e79e821bb47082";
    sha256 = "1am84a60adw0bb12rlhdqbiwyywhza4qp5sf4f4fmssjl2qcr6nl";
  };

  sourceRoot = "${src.name}/testing/geckodriver";

  cargoSha256 = "0dvcvdb623jla29i93glx20nf8pbpfw6jj548ii6brzkcpafxxm8";

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = https://github.com/mozilla/geckodriver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
