{ lib, buildGoModule, fetchFromGitHub, callPackage, stuffbin, nixosTests }:

buildGoModule rec {
  pname = "listmonk";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
    sha256 = "sha256-jhUibw6SP+BfqmUgxaJ4tDynnew5twMRKYXlezJwq40=";
  };

  vendorSha256 = "sha256-FmvSSRdOAW0mpBG454I7dYPY9crda2iTcA0UpJin6G8=";

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
