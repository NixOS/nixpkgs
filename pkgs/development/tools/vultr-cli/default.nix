<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.18.2";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.16.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RW8t5s28eUxHKEz+UHdeHlRMYprKlA9AdtiEy661des=";
  };

  vendorHash = "sha256-61hdhkFyp4an9KtqDzB4Sd2+t40QEoLgq7MvUBxEQKs=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd vultr-cli \
      --bash <($out/bin/vultr-cli completion bash) \
      --fish <($out/bin/vultr-cli completion fish) \
      --zsh <($out/bin/vultr-cli completion zsh)
  '';
=======
    hash = "sha256-TugONG98MC1+B9kDLH9xeMmD41fHNV8VCWWWtOdlwys=";
  };

  vendorHash = "sha256-P4xr7zVTwBRVoPxtKn3FNV7Vp6lI4uWdTJyXwex8Fe4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
<<<<<<< HEAD
    changelog = "https://github.com/vultr/vultr-cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "vultr-cli";
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
