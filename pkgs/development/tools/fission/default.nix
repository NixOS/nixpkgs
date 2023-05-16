{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
<<<<<<< HEAD
  version = "1.19.0";
=======
  version = "1.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-Ui7HGiWjzbhEOLuxC3TkFqDwwi3YsLMuxhZsPrJzPN0=";
  };

  vendorHash = "sha256-XQd5jTZ37DhvQq7x1OyhIb1uoMv5Y7Ayv4CX33BCLBE=";
=======
    rev = version;
    sha256 = "sha256-U/UV5NZXmycDp8+g5XV6P2b+4SutR51rVHdPp9HdPjM=";
  };

  vendorSha256 = "sha256-1ujJuhK7pm/A1Dd+Wm9dtc65mx9pwLBWMWwEJnbja8s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X info.Version=${version}" ];

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "The cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
