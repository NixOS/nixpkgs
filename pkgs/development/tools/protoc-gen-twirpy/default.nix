{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-twirpy";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "verloop";
    repo = "twirpy";
    rev = version;
    hash = "sha256-nhhWS7qePi5DxGirs3s9WCaiFcnDxnnSHWIfxjJQyck=";
  };

  vendorHash = "sha256-GLEzOSsa3sbjnHAPilvCDIw/Ba5KXWH0jtcFmI9gKlQ=";

  sourceRoot = "${src.name}/protoc-gen-twirpy";

  meta = with lib; {
    description =
      "Python implementation of Twirp RPC framework (supports Twirp Wire Protocol v7)";
    homepage = "https://github.com/verloop/twirpy";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dgollings ];
    platforms = platforms.unix;
  };
}
