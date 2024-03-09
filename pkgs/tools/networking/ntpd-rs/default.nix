{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pandoc
}:

rustPlatform.buildRustPackage rec {
  pname = "ntpd-rs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "ntpd-rs";
    rev = "v${version}";
    hash = "sha256-IoTuI0M+stZNUVpaVsf7JR7uHcamSSVDMJxJ+7n5ayA=";
  };

  cargoHash = "sha256-iZuDNFy8c2UZUh3J11lEtfHlDFN+qPl4iZg+ps7AenE=";

  nativeBuildInputs = [ pandoc installShellFiles ];

  postPatch = ''
    substituteInPlace utils/generate-man.sh \
      --replace 'utils/pandoc.sh' 'pandoc'
  '';

  postBuild = ''
    source utils/generate-man.sh
  '';

  doCheck = true;

  checkFlags = [
    # doesn't find the testca
    "--skip=keyexchange::tests::key_exchange_roundtrip"
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
  };
}
