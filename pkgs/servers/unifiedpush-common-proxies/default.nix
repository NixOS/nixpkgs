{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "unifiedpush-common-proxies";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "unifiedpush";
    repo = "common-proxies";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-eonKHhaH7mAdW7ouprQivMxKPGFv0s1m/S8jGwid8kM=";
  };

  vendorHash = "sha256-s0uN6PzIaAHLvRb9T07Xvb6mMAuvKHQ4oFJtl5hsvY4=";
=======
    sha256 = "sha256-spOLgSqiEySVc7imeTeg83MO5cw5nea0qD6OV8JRI6Y=";
  };

  vendorSha256 = "13mxdjc9fvajl0w78a5g1cqadgmxsx74zz8npp5h2s68zkl8sjxk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
    mainProgram = "up_rewrite";
  };
}
