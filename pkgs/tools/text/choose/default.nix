{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "choose";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "theryangeary";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QX0tAo1cGPpRhggiAPxsVhKXg6TgaVl1lcp3na7jUNw=";
  };

  cargoSha256 = "sha256-3pK7y/zC5iZkto5p5Xerlpu3yfN6sB2kjLF2fURlUj0=";

  meta = with lib; {
    description = "A human-friendly and fast alternative to cut and (sometimes) awk";
    homepage = "https://github.com/theryangeary/choose";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
