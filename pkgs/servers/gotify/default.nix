{ lib
, buildGoPackage
, fetchFromGitHub
, buildGoModule
, sqlite
, callPackage
}:

buildGoModule rec {
  pname = "gotify-server";
  # should be update just like all other files imported like that via the
  # `update.sh` script.
  version = import ./version.nix;

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = import ./source-sha.nix;
  };

  # With `allowGoReference = true;`, `buildGoModule` adds the `-trimpath`
  # argument for Go builds which apparently breaks the UI like this:
  #
  #   server[780]: stat /var/lib/private/ui/build/index.html: no such file or directory
  allowGoReference = true;

  vendorSha256 = import ./vendor-sha.nix;

  doCheck = false;

  buildInputs = [ sqlite ];

  ui = callPackage ./ui.nix { };

  preBuild = ''
    cp -r ${ui}/libexec/gotify-ui/deps/gotify-ui/build ui/build && go run hack/packr/packr.go
  '';

  passthru = {
    updateScript = ./update.sh;
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

}
