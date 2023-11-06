{ lib
, stdenv
, buildGoModule
, nodejs
, python3
, libtool
, npmHooks
, fetchFromGitHub
, fetchNpmDeps
}:

let

  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = "sha256-WPfr1LHOgOFsF2g3junJ0km0gOk/LC52jekJ8BXlqP0=";
  };

  # Separate derivation, because if we mix this in buildGoModule, the separate
  # go-modules build inherits specific attributes and fails. Getting that to
  # work is hackier than just splitting the build.
  ui = stdenv.mkDerivation {
    pname = "mailpit-ui";
    inherit src version;

    npmDeps = fetchNpmDeps {
      inherit src;
      hash = "sha256-RaXD+WfNywItveKzc+KWOw38H1EZ2yukgbMrtOfPSJc=";
    };

    nativeBuildInputs = [ nodejs python3 libtool npmHooks.npmConfigHook ];

    buildPhase = ''
      npm run package
    '';

    installPhase = ''
      mv server/ui/dist $out
    '';
  };

in

buildGoModule {
  pname = "mailpit";
  inherit src version;

  vendorHash = "sha256-akt72aBoiQKp1Hxf3NgzSmfgmsnjpheIh62lPCTyHBs=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X github.com/axllent/mailpit/config.Version=${version}" ];

  preBuild = ''
    cp -r ${ui} server/ui/dist
  '';

  meta = with lib; {
    description = "An email and SMTP testing tool with API for developers";
    homepage = "https://github.com/axllent/mailpit";
    changelog = "https://github.com/axllent/mailpit/releases/tag/v${version}";
    maintainers = with maintainers; [ stephank ];
    license = licenses.mit;
    mainProgram = "mailpit";
  };
}
