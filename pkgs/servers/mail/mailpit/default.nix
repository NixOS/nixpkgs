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
}:

let
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = "sha256-5QEn4sEZgtoFrVonZsAtvzhEkxYGDEWwhJOxqwWQJTk=";
  };

  # Separate derivation, because if we mix this in buildGoModule, the separate
  # go-modules build inherits specific attributes and fails. Getting that to
  # work is hackier than just splitting the build.
  ui = stdenv.mkDerivation {
    pname = "mailpit-ui";
    inherit src version;

    npmDeps = fetchNpmDeps {
      inherit src;
      hash = "sha256-5F68ia2V8mw4iPAjSoz0b8z1lplWtAg98BgDXYOmMKs=";
    };

    env = lib.optionalAttrs (stdenv.isDarwin && stdenv.isx86_64) {
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
  inherit src version;

  vendorHash = "sha256-e2mlOwGDU5NlKZSstHMdTidSfhNeeY6cBgtW+W9nwV8=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/axllent/mailpit/config.Version=${version}"
  ];

  preBuild = ''
    cp -r ${ui} server/ui/dist
  '';

  passthru.tests.version = testers.testVersion {
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
