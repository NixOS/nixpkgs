{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
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

  cargoHash = "sha256-vWAFWoscV0swwrBQoa3glKXMRgdGYa+QrPprlVCP1QM=";

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
