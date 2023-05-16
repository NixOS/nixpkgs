{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wormhole-william";
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "1.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "wormhole-william";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-KLj9ZeLcIOWA4VeuxfoOr99kUCDb7OARX/h9DSG1WHw=";
  };

  vendorHash = "sha256-oJz7HgtjuP4ooXdpofIKaDndGg4WqVZgbT8Yb1AyaMs=";
=======
    sha256 = "sha256-L/0zgQkwADElpIzOJAROa3CN/YNl76Af2pAhX8y2Wxs=";
  };

  vendorSha256 = "sha256-J6iht3cagcwFekydShgaYJtkNLfEvSDqonkC7+frldM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    # wormhole_test.go:692: failed to establish connection
    substituteInPlace wormhole/wormhole_test.go \
      --replace "TestWormholeDirectoryTransportSendRecvDirect" \
                "SkipWormholeDirectoryTransportSendRecvDirect"
  '';

  meta = with lib; {
    homepage = "https://github.com/psanford/wormhole-william";
    description = "End-to-end encrypted file transfers";
    changelog = "https://github.com/psanford/wormhole-william/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psanford ];
  };
}
