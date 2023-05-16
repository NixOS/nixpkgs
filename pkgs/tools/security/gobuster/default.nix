{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobuster";
<<<<<<< HEAD
  version = "3.6.0";
=======
  version = "3.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-LZL9Zje2u0v6iAQinfjflvusV57ys5J5Il6Q7br3Suc=";
  };

  vendorHash = "sha256-w+G5PsWXhKipjYIHtz633sia+Wg9FSFVpcugEl8fp0E=";

  ldflags = [
    "-s"
    "-w"
  ];
=======
    rev = "v${version}";
    hash = "sha256-Ohv/FgMbniItbrcrncAe9QKVjrhxoZ80BGYJmJtJpPk=";
  };

  vendorHash = "sha256-ZbY5PyXKcTB9spVGfW2Qhj8SV9alOSH0DyXx1dh/NgQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    changelog = "https://github.com/OJ/gobuster/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ fab pamplemousse ];
=======
    maintainers = with maintainers; [ pamplemousse ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
