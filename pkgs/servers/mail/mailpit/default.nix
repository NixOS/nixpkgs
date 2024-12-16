{
  lib,
  stdenv,
  buildGoModule,
  nodejs,
  python3,
  libtool,
  npmHooks,
  fetchFromGitHub,
  fetchNpmDeps,
  testers,
  mailpit,
  nixosTests,
}:

let
  source = import ./source.nix;

  inherit (source)
    version
    vendorHash
    ;

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = source.hash;
  };

  # Separate derivation, because if we mix this in buildGoModule, the separate
  # go-modules build inherits specific attributes and fails. Getting that to
  # work is hackier than just splitting the build.
  ui = stdenv.mkDerivation {
    pname = "mailpit-ui";
    inherit src version;

    npmDeps = fetchNpmDeps {
      inherit src;
      hash = source.npmDepsHash;
    };

    env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
      # Make sure libc++ uses `posix_memalign` instead of `aligned_alloc` on x86_64-darwin.
      # Otherwise, nodejs would require the 11.0 SDK and macOS 10.15+.
      NIX_CFLAGS_COMPILE = "-D__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__=101300";
    };

    nativeBuildInputs = [
      nodejs
      python3
      libtool
      npmHooks.npmConfigHook
    ];

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
  inherit src version vendorHash;

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/axllent/mailpit/config.Version=${version}"
  ];

  preBuild = ''
    cp -r ${ui} server/ui/dist
  '';

  passthru.tests = {
    inherit (nixosTests) mailpit;
    version = testers.testVersion {
      package = mailpit;
      command = "mailpit version";
    };
  };

  passthru.updateScript = {
    supportedFeatures = [ "commit" ];
    command = ./update.sh;
  };

  meta = with lib; {
    description = "Email and SMTP testing tool with API for developers";
    homepage = "https://github.com/axllent/mailpit";
    changelog = "https://github.com/axllent/mailpit/releases/tag/v${version}";
    maintainers = with maintainers; [ stephank ];
    license = licenses.mit;
    mainProgram = "mailpit";
  };
}
