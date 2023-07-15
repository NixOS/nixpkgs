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

  version = "0.9.0";
  source-hash = "sha256-UZRIQTdVESCYv2KW7HUS2c4bS5qnB7wdwiYAgEJ60fU=";
  web-assets-hash = "sha256-OvgAr3obsK1JndLKmnjNY06dEbQKyP4xG/viBjCivvs=";

  web-assets = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = web-assets-hash;
  };
in
buildGoModule rec {
  inherit version;
  pname = repo;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "refs/tags/v${version}";
    hash = source-hash;
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
