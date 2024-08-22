{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.8";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-ifE+6lwBYVZl0eAOCUTrqqTwVnKvCB44AHXTyLhsMX8=";
  };

  vendorHash = "sha256-yh7hAKmt2qn2jmPKGF+ATvZd4miNHuHsKlFNaWibTJQ=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marie ];
  };
}
