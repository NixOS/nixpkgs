{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "sops";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q1e3iRIne9/bCLxKdhzP3vt3oxuHJAuG273HdeHZ3so=";
  };

  vendorHash = "sha256-3vzKQZTg38/UGVJ/M1jLALCgor7wztsLKVuMqY3adtI=";

  subPackages = [ "cmd/sops" ];

  ldflags = [ "-s" "-w" "-X github.com/getsops/sops/v3/version.Version=${version}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://getsops.io/";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${version}/CHANGELOG.rst";
    mainProgram = "sops";
    maintainers = with maintainers; [ Scrumplex mic92 ];
    license = licenses.mpl20;
  };
}
