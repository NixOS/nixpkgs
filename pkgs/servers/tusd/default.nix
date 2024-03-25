{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "tusd";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "tus";
    repo = "tusd";
    rev = "v${version}";
    sha256 = "1vywmrr2i9zyidjilqmlq16zd41iapbcii9n4cqyxkvqym1nwi2p";
  };

  vendorSha256 = "017vn2gl531jrdszl6l9k5ajcw2nn0c3vs5aaqd1c6cm20x6baqv";

  passthru.tests.tusd = nixosTests.tusd;

  meta = with lib; {
    description = "Reference server implementation in Go of tus: the open protocol for resumable file uploads";
    license = licenses.mit;
    homepage = "https://tus.io/";
    maintainers = with maintainers; [ nh2 ];
  };
}
