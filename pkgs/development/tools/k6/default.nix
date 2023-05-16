{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "k6";
<<<<<<< HEAD
  version = "0.46.0";
=======
  version = "0.44.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-4ucnq/FTvdDpzf1RWRY+U5A+BCaaQWMTEaZtmU0JD90=";
=======
    sha256 = "sha256-BfzB6Qt0Hg9ryU4zeTi40jByOgqr9mveq5ZGkO8bA9U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "./" ];

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/k6 version | grep ${version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    installShellCompletion --cmd k6 \
      --bash <($out/bin/k6 completion bash) \
      --fish <($out/bin/k6 completion fish) \
      --zsh <($out/bin/k6 completion zsh)
  '';

  meta = with lib; {
    description = "A modern load testing tool, using Go and JavaScript";
    homepage = "https://k6.io/";
    changelog = "https://github.com/grafana/k6/releases/tag/v${version}";
    license = licenses.agpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ offline bryanasdev000 kashw2 ];
=======
    maintainers = with maintainers; [ offline bryanasdev000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
