<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, callPackage, stuffbin, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "listmonk";
  version = "2.5.1";
=======
{ lib, buildGoModule, fetchFromGitHub, callPackage, stuffbin, nixosTests }:

buildGoModule rec {
  pname = "listmonk";
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gCnIblc83CmG1auvYYxqW/xBl6Oy1KHGkqSY/3yIm3I=";
  };

  patches = [
    # Ensure that listmonk supports Go 1.20
    (fetchpatch {
      url = "https://github.com/knadh/listmonk/commit/25513b81044803b104ada63c0be57a913960484e.patch";
      hash = "sha256-SYACM8r+NgeSWn9VJV4+wkm+6s/MhNGwn5zyc2tw7FU=";
    })
  ];

  vendorHash = "sha256-0sgC1+ueZTUCP+7JwI/OKLktfMHQq959GEk1mC0TQgE=";
=======
    sha256 = "sha256-dtIM0dkr8y+GbyCqrBlR5VRq6qMiZdmQyFvIoVY1eUg=";
  };

  vendorSha256 = "sha256-qeBuDM3REUxgu3ty02d7qsULH04USE0JUvBrtVnW8vg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    stuffbin
  ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/listmonk
  '';

  # Run stuffbin to stuff the frontend and the static in the binary.
  postFixup =
    let
      vfsMappings = [
        "config.toml.sample"
        "schema.sql"
        "queries.sql"
        "static/public:/public"
        "static/email-templates"
        "${passthru.frontend}:/admin"
        "i18n:/i18n"
      ];
    in
      ''
        stuffbin -a stuff -in $out/bin/listmonk -out $out/bin/listmonk \
          ${lib.concatStringsSep " " vfsMappings}
      '';

  passthru = {
    frontend = callPackage ./frontend.nix { inherit meta; };
    tests = { inherit (nixosTests) listmonk; };
  };

  meta = with lib; {
    description = "High performance, self-hosted, newsletter and mailing list manager with a modern dashboard.";
    homepage = "https://github.com/knadh/listmonk";
    changelog = "https://github.com/knadh/listmonk/releases/tag/v${version}";
    maintainers = with maintainers; [ raitobezarius ];
    license = licenses.agpl3;
  };
}
