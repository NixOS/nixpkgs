{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "babelfish";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "babelfish";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-/rWX77n9wqWxkHG7gVOinCJ6ahuEfbAcGijC1oAxrno=";
  };

  vendorHash = "sha256-HY9ejLfT6gj3vUMSzbNZ4QlpB+liigTtNDBNWCy8X38=";
=======
    sha256 = "0b1knj9llwzwnl4w3d6akvlc57dp0fszjkq98w8wybcvkbpd3ip1";
  };

  vendorSha256 = "0kspqwbgiqfkfj9a9pdwzc0jdi9p35abqqqjhcpvqwdxw378w5lz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Translate bash scripts to fish";
    homepage = "https://github.com/bouk/babelfish";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk kevingriffin ];
  };
}
