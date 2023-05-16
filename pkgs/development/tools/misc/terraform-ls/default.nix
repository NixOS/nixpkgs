<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.31.5";
=======
{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.30.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vpPvmWcmA0m2D1M67pcpJwT7oRM1IL56e7LgWWl+YFE=";
  };

  vendorHash = "sha256-jrpgMweoA/ZzSDdjc/ZvZcYArg8f6XPZCbznz6yGPfI=";

  ldflags = [ "-s" "-w" ];
=======
    sha256 = "sha256-enPnj4/p83hQkVv821MGyGipgEmVo12IZzy/3y8UprQ=";
  };
  vendorSha256 = "sha256-U3zslBDVz5nvhNgcn5L84hSUolf7XFCuh7zMZxyW/gQ=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" "-X main.prerelease=" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # There's a mixture of tests that use networking and several that fail on aarch64
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terraform-ls --help
<<<<<<< HEAD
    $out/bin/terraform-ls --version | grep "${version}"
=======
    $out/bin/terraform-ls version | grep "v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie jk ];
  };
}
