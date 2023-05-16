{ lib
, buildGoPackage
, fetchFromGitHub
, buildGoModule
, sqlite
, callPackage
<<<<<<< HEAD
, nixosTests
, nix-update-script
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "gotify-server";
<<<<<<< HEAD
  version = "2.3.0";
=======
  # should be update just like all other files imported like that via the
  # `update.sh` script.
  version = import ./version.nix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fWcdnmpLZycg7hmPNnphGcuSMTI4bsq57XPoSyQSGDA=";
=======
    sha256 = import ./source-sha.nix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # With `allowGoReference = true;`, `buildGoModule` adds the `-trimpath`
  # argument for Go builds which apparently breaks the UI like this:
  #
  #   server[780]: stat /var/lib/private/ui/build/index.html: no such file or directory
  allowGoReference = true;

<<<<<<< HEAD
  vendorHash = "sha256-im7Pauit0tWi0BcyKtxybOqsu7rrIHZwY5Olta3nJJI=";

  doCheck = false;

  buildInputs = [
    sqlite
  ];
=======
  vendorSha256 = import ./vendor-sha.nix;

  doCheck = false;

  buildInputs = [ sqlite ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ui = callPackage ./ui.nix { };

  preBuild = ''
<<<<<<< HEAD
    if [ -n "$ui" ] # to make the preBuild a no-op inside the goModules fixed-output derivation, where it would fail
    then
      cp -r $ui ui/build
    fi
  '';

  passthru = {
    # For nix-update to detect the location of this attribute from this
    # derivation.
    inherit (ui) offlineCache;
    updateScript = nix-update-script { };
    tests = {
      nixos = nixosTests.gotify-server;
    };
=======
    cp -r ${ui}/libexec/gotify-ui/deps/gotify-ui/build ui/build && go run hack/packr/packr.go
  '';

  passthru = {
    updateScript = ./update.sh;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Otherwise, all other subpackages are built as well and from some reason,
  # produce binaries which panic when executed and are not interesting at all
  subPackages = [ "." ];

  ldflags = [
    "-X main.Version=${version}" "-X main.Mode=prod"
  ];

  meta = with lib; {
    description = "A simple server for sending and receiving messages in real-time per WebSocket";
    homepage = "https://gotify.net";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "server";
  };
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
