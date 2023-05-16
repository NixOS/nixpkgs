{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
<<<<<<< HEAD
  version = "0.13.2";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
<<<<<<< HEAD
    hash = "sha256-fRpVAYg4UwRe3bcjQPOnCGWSANfoTwD5Y9vs3QET1eM=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-9d7vgCMc1M5Cab+O10lQmKGfL9gqO3sajd+3rF5cums=";
=======
    sha256 = "sha256-49TDAxFx4kSwCn1YGQgMn3xLG3RHCCttMzqUfm4OPtE=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-1/stMvxsCs2OPMN7KGbZ61s2qGT5Yg7kHVHsWi6ekcY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}
