{ buildGoModule, fetchFromGitHub, lib  }:

with lib;

buildGoModule rec {
  pname   = "nats-streaming-server";
<<<<<<< HEAD
  version = "0.25.5";
=======
  version = "0.25.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
<<<<<<< HEAD
    sha256 = "sha256-rx6H3YXyg53th81w1SsKg5h9wj2vswnArDO0TNUlvpE=";
  };

  vendorHash = "sha256-erTxz3YpE64muc9OgP38BrPNH5o3tStSYsCbBd++kFU=";
=======
    sha256 = "sha256-/uPkcJOUDPVcdNBo6PxbJEvrrbElQ8lzMERZv6lOZwQ=";
  };

  vendorHash = "sha256-Ah7F4+l1Bmr5j15x7fsEOzFIvxDR4OuJFTY95ZYyOYc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests fail and ask to `go install`
  doCheck = false;

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
