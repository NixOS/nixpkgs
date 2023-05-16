{ lib
, buildGoModule
, fetchFromGitHub
}:
<<<<<<< HEAD

buildGoModule rec {
  pname = "earlybird";
  version = "3.16.0";
=======
buildGoModule {
  pname = "earlybird";
  version = "1.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "americanexpress";
    repo = "earlybird";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-qSW8O13UW5L2eVsqIuqOguhCyZBPqevZ9fJ7qkraa7M=";
  };

  patches = [
    ./fix-go.mod-dependency.patch
  ];

  vendorHash = "sha256-ktsQvWc0CTnqOer+9cc0BddrQp0F3Xk7YJP3jxfuw1w=";

  ldflags = [ "-s" "-w" ];
=======
    # According to the GitHub repo, the latest version *is* 1.25.0, but they
    # tagged it as "refs/heads/main-2"
    rev = "4f365f1c02972dc0a68a196a262912d9c4325b21";
    sha256 = "UZXHYBwBmb9J1HrE/htPZcKvZ+7mc+oXnUtzgBmBgN4=";
  };

  vendorSha256 = "oSHBR1EvK/1+cXqGNCE9tWn6Kd/BwNY3m5XrKCAijhA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A sensitive data detection tool capable of scanning source code repositories for passwords, key files, and more";
    homepage = "https://github.com/americanexpress/earlybird";
<<<<<<< HEAD
    changelog = "https://github.com/americanexpress/earlybird/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = [ ];
  };
}
