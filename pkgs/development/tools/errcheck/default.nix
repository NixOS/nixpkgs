{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "errcheck";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${version}";
    sha256 = "sha256-Przf2c2jFNdkUq7IOUD7ChXHiSayAz4xTsNzajycYZ0=";
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
