{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, buildGoModule
, nixosTests
}:
let
  owner = "superseriousbusiness";
  repo = "gotosocial";

  version = "0.12.2";

  web-assets = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = "sha256-vEjL9pZFBSt32ZqWZGvG112HA5nqkwY6uOQY3hBUWN4=";
  };
in
buildGoModule rec {
  inherit version;
  pname = repo;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "refs/tags/v${version}";
    hash = "sha256-ufxedg3SSHqYf5g1GXXSWA0pmb305kpjkjyjwCX126A=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    tar xf ${web-assets}
    mkdir -p $out/share/gotosocial
    mv web $out/share/gotosocial/
  '';

  # tests are working only on x86_64-linux
  doCheck = stdenv.isLinux && stdenv.isx86_64;

  passthru.tests.gotosocial = nixosTests.gotosocial;

  meta = with lib; {
    homepage = "https://gotosocial.org";
    changelog = "https://github.com/superseriousbusiness/gotosocial/releases/tag/v${version}";
    description = "Fast, fun, ActivityPub server, powered by Go";
    longDescription = ''
      ActivityPub social network server, written in Golang.
      You can keep in touch with your friends, post, read, and
      share images and articles. All without being tracked or
      advertised to! A light-weight alternative to Mastodon
      and Pleroma, with support for clients!
    '';
    maintainers = with maintainers; [ misuzu ];
    license = licenses.agpl3Only;
  };
}
