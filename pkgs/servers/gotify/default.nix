{ stdenv
, buildGoPackage
, lib
, fetchFromGitHub
, buildGoModule
, packr
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

  vendorSha256 = import ./vendor-sha.nix;

  postPatch = ''
    substituteInPlace app.go \
      --replace 'Version = "unknown"' 'Version = "${version}"'
  '';

  buildInputs = [ sqlite ];

  nativeBuildInputs = [ packr ];

  ui = callPackage ./ui.nix { };

  preBuild = ''
    cp -r ${ui}/libexec/gotify-ui/deps/gotify-ui/build ui/build && packr
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  # Otherwise, all other subpackages are built as well and from some reason,
  # produce binaries which panic when executed and are not interesting at all
  subPackages = [ "." ];

  buildFlagsArray = [
    "-ldflags='-X main.Version=${version} -X main.Mode=prod'"
  ];

  meta = with stdenv.lib; {
    description = "A simple server for sending and receiving messages in real-time per WebSocket";
    homepage = "https://gotify.net";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };

}
