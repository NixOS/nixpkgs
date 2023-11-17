{ lib
, stdenv
, buildGoModule
, nodejs
, python3
, libtool
, npmHooks
, fetchFromGitHub
, fetchNpmDeps
, testers
, mailpit
}:

let

  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = "sha256-MrhTgyY89rU2EQILRSFJk8U7QWaoUf2p83ksFjA7xOM=";
  };

  # Separate derivation, because if we mix this in buildGoModule, the separate
  # go-modules build inherits specific attributes and fails. Getting that to
  # work is hackier than just splitting the build.
  ui = stdenv.mkDerivation {
    pname = "mailpit-ui";
    inherit src version;

    npmDeps = fetchNpmDeps {
      inherit src;
      hash = "sha256-r4yv2qImIlNMPJagz5i1sxqBDnFAucc2kDUmjGktM6A=";
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

  vendorHash = "sha256-TXa97oOul9cf07uNGdIoxIM++da5HBFeoh05LaJzQTA=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X github.com/axllent/mailpit/config.Version=${version}" ];

  preBuild = ''
    cp -r ${ui} server/ui/dist
  '';

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = mailpit;
    command = "mailpit version";
  };

  meta = with lib; {
    description = "An email and SMTP testing tool with API for developers";
    homepage = "https://github.com/axllent/mailpit";
    changelog = "https://github.com/axllent/mailpit/releases/tag/v${version}";
    maintainers = with maintainers; [ stephank ];
    license = licenses.mit;
    mainProgram = "mailpit";
  };
}
