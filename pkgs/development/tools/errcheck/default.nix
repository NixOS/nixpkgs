{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "errcheck";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${version}";
    sha256 = "sha256-ZmocFXtg+Thdup+RqDYC/Td3+m1nS0FydZecfsWXIzI=";
  };

  vendorSha256 = "sha256-rluaBdW+w2zPThELlBwX/6LXDgc2aIk/ucbrsrABpVc=";

  meta = with lib; {
    description = "Program for checking for unchecked errors in go programs";
    homepage = "https://github.com/kisielk/errcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
