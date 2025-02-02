{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.10";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-D0x+87bKVtZPHJcwZUJ49JXp2o32ieOw/etnE69c8CI=";
  };

  vendorHash = "sha256-2oEIBIr8oc1ku/k9mlLSg6Q6BbUleufvlmWOaV6wPfU=";

  excludedPackages = [
    "build"
    "man"
  ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      vdemeester
      marie
    ];
  };
}
