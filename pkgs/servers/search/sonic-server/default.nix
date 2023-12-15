{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
, nix-update-script
, nixosTests
, testers
, sonic-server
}:

rustPlatform.buildRustPackage rec {
  pname = "sonic-server";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "valeriansaliou";
    repo = "sonic";
    rev = "refs/tags/v${version}";
    hash = "sha256-V97K4KS46DXje4qKA11O9NEm0s13aTUnM+XW8lGc6fo=";
  };

  cargoPatches = [
    # Update rocksdb to 0.21 to fix compilation issues against clang 16, see:
    # https://github.com/valeriansaliou/sonic/issues/315
    # https://github.com/valeriansaliou/sonic/pull/316
    (fetchpatch {
      url = "https://github.com/valeriansaliou/sonic/commit/81d5f1efec21ef8b911ed3303fcbe9ca6335f562.patch";
      hash = "sha256-nOvHThTc2L3UQRVusUsD/OzbSkhSleZc6n0WyZducHM=";
    })
  ];

  cargoHash = "sha256-k+gPCkf8DCnuv/aLXcQwjmsDUu/eqSEqKXlUyj8bRq8=";

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  postPatch = ''
    substituteInPlace src/main.rs --replace "./config.cfg" "$out/etc/sonic/config.cfg"
  '';

  postInstall = ''
    install -Dm444 -t $out/etc/sonic config.cfg
    install -Dm444 -t $out/lib/systemd/system debian/sonic.service

    substituteInPlace \
      $out/lib/systemd/system/sonic.service \
      --replace /usr/bin/sonic $out/bin/sonic \
      --replace /etc/sonic.cfg $out/etc/sonic/config.cfg
  '';

  passthru = {
    tests = {
      inherit (nixosTests) sonic-server;
      version = testers.testVersion {
        command = "sonic --version";
        package = sonic-server;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Fast, lightweight and schema-less search backend";
    homepage = "https://github.com/valeriansaliou/sonic";
    changelog = "https://github.com/valeriansaliou/sonic/releases/tag/v${version}";
    license = licenses.mpl20;
    platforms = platforms.unix;
    mainProgram = "sonic";
    maintainers = with maintainers; [ pleshevskiy anthonyroussel ];
  };
}
