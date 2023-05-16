<<<<<<< HEAD
{ lib, buildGo121Module, fetchFromGitHub, installShellFiles, testers, sq }:

buildGo121Module rec {
  pname = "sq";
  version = "0.42.0";
=======
{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:

buildGoModule rec {
  pname = "sq";
  version = "0.33.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IL3041R35WL+sYCpTjfPXUpd7GTcQoaILYBufwH1WoE=";
  };

  vendorHash = "sha256-ez5qhGgK0q3oDT0L0Fs+JKJjMbNoJukzCoir2a9ro48=";
=======
    sha256 = "sha256-1I6adQLbVx4Gj9rdocpEPyQagEpaI4a4sHUaSyntyGI=";
  };

  vendorHash = "sha256-e14qz4KTD2aAl1G5wj2/T0cxocvscj0r+c8So+omA38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd sq \
      --bash <($out/bin/sq completion bash) \
      --fish <($out/bin/sq completion fish) \
      --zsh <($out/bin/sq completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = sq;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
