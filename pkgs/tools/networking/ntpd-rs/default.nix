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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pendulum-project";
    repo = "ntpd-rs";
    rev = "v${version}";
    hash = "sha256-yIX9RD1xqkFoxDt82wnKfQR3z/vLA0I5/cptaIgSNjw=";
  };

  cargoHash = "sha256-NRFmb9rZVbd0qYKIkslT4TcbC/aD4QhAjm2GA4BvReY=";

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

  meta = {
    description = "Full-featured implementation of the Network Time Protocol";
    homepage = "https://tweedegolf.nl/en/pendulum";
    changelog = "https://github.com/pendulum-project/ntpd-rs/blob/v${version}/CHANGELOG.md";
    mainProgram = "ntp-ctl";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      fpletz
      getchoo
    ];
    # note: Undefined symbols for architecture x86_64: "_ntp_adjtime"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
