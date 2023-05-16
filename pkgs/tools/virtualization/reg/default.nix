{ lib
, fetchpatch
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "reg";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "genuinetools";
    repo = "reg";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tfBetjoJkr84XLEEcfdRTtc0UZ4m/uRH1Fpr91lQn8o=";
=======
    sha256 = "1jlza1czfssssi3y9zi6kr8k9msfa7vp215ibhwbz4h97av5xw5m";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # https://github.com/genuinetools/reg/pull/218
    (fetchpatch {
      name = "update-x-sys-for-go-1.18-on-aarch64-darwin.patch";
      url = "https://github.com/genuinetools/reg/commit/f37b04ad8be47f1e68ef9b2c5906324d7096231e.patch";
      hash = "sha256-wmBjPdrpNpxx//I+d+k8DNR11TmyXxb84vXR/MrYHKA=";
    })
    (fetchpatch {
      name = "update-vendored-dependencies.patch";
      url = "https://github.com/genuinetools/reg/commit/8bb04bc3fd41c089716e65ee905c6feac8bda5a0.patch";
      hash = "sha256-5nZaayy0xu7sOJHVCp6AotINiF7vXk2Jic8SR8ZrH/g=";
    })
  ];

<<<<<<< HEAD
  vendorHash = null;
=======
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  meta = with lib; {
    description = "Docker registry v2 command line client and repo listing generator with security checks";
    homepage = "https://github.com/genuinetools/reg";
    license = licenses.mit;
    maintainers = with maintainers; [ ereslibre ];
  };
}
