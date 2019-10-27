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
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "0f7y6gkxikdfjhdxplkv494ss2b0fqmibd2kl9nifabggfz5gjal";
  };

  modSha256 = "19mghbs1jasb7vxdw13mmwsbk5sfg3y2vvddr73c82lq0f8g2iha";

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
