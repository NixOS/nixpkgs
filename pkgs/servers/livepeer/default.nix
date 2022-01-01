{ lib, fetchFromGitHub, buildGoModule
, pkg-config, ffmpeg, gnutls
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.24";

  proxyVendor = true;
  vendorSha256 = "sha256-iW8ZS8bXvyftkqmtRTyc8RaIk87x07ZilbhJkgA0ZIU=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "v${version}";
    sha256 = "sha256-GPazmi17v5yO4qudnf3hytuTD1WH0KAnVBzRLkk43fw=";
  };

  subPackages = [
    "cmd/livepeer_bench"
    "cmd/livepeer_cli"
    "cmd/livepeer_router"
    "cmd/livepeer"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg gnutls ];

  # tests fail
  doCheck = false;

  meta = with lib; {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = "https://livepeer.org";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
  };
}
