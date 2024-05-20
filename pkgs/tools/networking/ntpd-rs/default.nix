{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pandoc
, Security
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

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];
  nativeBuildInputs = [ pandoc installShellFiles ];

  postPatch = ''
    substituteInPlace utils/generate-man.sh \
      --replace 'utils/pandoc.sh' 'pandoc'
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

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "A full-featured implementation of the Network Time Protocol";
    homepage = "https://tweedegolf.nl/en/pendulum";
    changelog = "https://github.com/pendulum-project/ntpd-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ fpletz ];
    # note: Undefined symbols for architecture x86_64: "_ntp_adjtime"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
