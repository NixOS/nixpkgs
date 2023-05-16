{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
<<<<<<< HEAD
  version = "1.3.2";
=======
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-oM4A4chSBTiCMr3bW0AvjAFlyuqvKKKY2Ji4PYRsUqA=";
  };

  vendorHash = "sha256-EeoJssX/OkIJKltANfvMirvDVmVVIe9hDj+rThKpd10=";
=======
    hash = "sha256-zz9p35Wk5jwp5Cn4+FgJCwG2KKgBuOQsH4lJeAVhpCM=";
  };

  vendorHash = "sha256-s6aEq3LzCj9xzieLD1aC69KV3aeav+bQ5VUZ3TbFetw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
