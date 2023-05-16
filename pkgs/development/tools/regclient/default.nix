{ stdenv, lib, buildGoModule, fetchFromGitHub }:

let bins = [ "regbot" "regctl" "regsync" ]; in

buildGoModule rec {
  pname = "regclient";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.4.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "regclient";
    repo = "regclient";
    rev = tag;
<<<<<<< HEAD
    sha256 = "sha256-mlwEUVMUXK2V8jzwDb51xjJElHhqioAsbq65R7rNS/Q=";
  };
  vendorHash = "sha256-AeC5Zv30BLkqaAPnWDrpGaJnhFoNJ9UgQaLEUmqXgb0=";
=======
    sha256 = "sha256-v8iWcgad5ku4/F3KfGOxh0A1t9qOOFzA6UDec0dYE3Y=";
  };
  vendorHash = "sha256-xkb1XXNY+ZO+GtYyLpOQftcyq6rj3bJu5HCeGJYsMDQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" ] ++ bins;

  ldflags = [
    "-s"
    "-w"
    "-X main.VCSTag=${tag}"
  ];

  postInstall =
    lib.concatStringsSep "\n" (
      map (bin: ''
        mkdir -p ''$${bin}/bin &&
        mv $out/bin/${bin} ''$${bin}/bin/ &&
        ln -s ''$${bin}/bin/${bin} $out/bin/
      '') bins
    );

  meta = with lib; {
    description = "Docker and OCI Registry Client in Go and tooling using those libraries";
    homepage = "https://github.com/regclient/regclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
