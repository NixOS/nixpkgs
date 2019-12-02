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
  # Note that when this is updated, along with the hash, the `ui.nix` file
  # should include the same changes to the version and the sha256.
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    rev = "v${version}";
    sha256 = "0zrylyaxy1cks1wlzyf0di8in2braj4pfriyqa24vipwrlnhvgs6";
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
