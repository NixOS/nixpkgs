{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  ntpd-rs,
  installShellFiles,
  pandoc,
  Security,
  nixosTests,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "ntpd-rs";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "ntpd-rs";
    rev = "v${version}";
    hash = "sha256-0ykJruuyD1Z/QcmrogodNlMZp05ocXIo3wdygB/AnT0=";
  };

  cargoHash = "sha256-Badq3GYr7BoF8VNGGtKTT4/ksuds1zBcSxx5O3vLbzg=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [
    pandoc
    installShellFiles
  ];

  postPatch = ''
    substituteInPlace utils/generate-man.sh \
      --replace-fail 'utils/pandoc.sh' 'pandoc'
  '';

  postBuild = ''
    source utils/generate-man.sh
  '';

  checkFlags = [
    # doesn't find the testca
    "--skip=daemon::keyexchange::tests"
    # seems flaky?
    "--skip=algorithm::kalman::peer::tests::test_offset_steering_and_measurements"
    # needs networking
    "--skip=hwtimestamp::tests::get_hwtimestamp"
  ];

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system docs/examples/conf/{ntpd-rs,ntpd-rs-metrics}.service
    installManPage docs/precompiled/man/{ntp.toml.5,ntp-ctl.8,ntp-daemon.8,ntp-metrics-exporter.8}
  '';

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    tests = {
      nixos = lib.optionalAttrs stdenv.isLinux nixosTests.ntpd-rs;
      version = testers.testVersion {
        package = ntpd-rs;
        inherit version;
      };
    };
  };

  meta = with lib; {
    description = "Full-featured implementation of the Network Time Protocol";
    homepage = "https://tweedegolf.nl/en/pendulum";
    changelog = "https://github.com/pendulum-project/ntpd-rs/blob/v${version}/CHANGELOG.md";
    mainProgram = "ntp-ctl";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      fpletz
      getchoo
    ];
    # note: Undefined symbols for architecture x86_64: "_ntp_adjtime"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
