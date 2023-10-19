{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ntpd-rs";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "ntpd-rs";
    rev = "v${version}";
    hash = "sha256-AUCzsveG9U+KxYO/4LGmyCPkR+w9pGDA/vTzMAGiVuI=";
  };

  cargoHash = "sha256-6FUVkr3uock43ZBHuMEVIZ5F8Oh8wMifh2EokMWv4hU=";

  checkFlags = [
    # doesn't find the testca
    "--skip=keyexchange::tests::key_exchange_roundtrip"
    # seems flaky
    "--skip=algorithm::kalman::peer::tests::test_offset_steering_and_measurements"
    # needs networking
    "--skip=hwtimestamp::tests::get_hwtimestamp"
  ];

  postInstall = ''
    install -vDt $out/lib/systemd/system pkg/common/ntpd-rs.service

    for testprog in demobilize-server rate-limit-server nts-ke nts-ke-server peer-state simple-daemon; do
      moveToOutput bin/$testprog "$tests"
    done
  '';

  outputs = [ "out" "tests" ];

  meta = with lib; {
    description = "A full-featured implementation of the Network Time Protocol";
    homepage = "https://tweedegolf.nl/en/pendulum";
    changelog = "https://github.com/pendulum-project/ntpd-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ fpletz ];
  };
}
