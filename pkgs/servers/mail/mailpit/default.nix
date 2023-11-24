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
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = "sha256-6nACvAhmFsZGWOqa3pwFqJLnh6Cueq2eYeg4Ns8gCmk=";
  };

  # Separate derivation, because if we mix this in buildGoModule, the separate
  # go-modules build inherits specific attributes and fails. Getting that to
  # work is hackier than just splitting the build.
  ui = stdenv.mkDerivation {
    pname = "mailpit-ui";
    inherit src version;

    npmDeps = fetchNpmDeps {
      inherit src;
      hash = "sha256-DlklRc9Mt4bMAOm/dZnvWPU74oGkc8RLof37Q/977Tk=";
    };

    env = lib.optionalAttrs (stdenv.isDarwin && stdenv.isx86_64) {
      # Make sure libc++ uses `posix_memalign` instead of `aligned_alloc` on x86_64-darwin.
      # Otherwise, nodejs would require the 11.0 SDK and macOS 10.15+.
      NIX_CFLAGS_COMPILE = "-D__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__=101300";
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

  vendorHash = "sha256-COkJF6JX4NnlPtCeGjaTLYvAKgXEhh+AJC0R9V7J4CM=";

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
