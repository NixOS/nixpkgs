{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openbsd_snmp3_check,
  python3,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "openbsd_snmp3_check";
  version = "0.55";

  src = fetchFromGitHub {
    owner = "alexander-naumov";
    repo = "openbsd_snmp3_check";
    rev = "v${version}";
    sha256 = "sha256-qDYANMvQU72f9wz8os7S1PfBH08AAqhtWLHVuSmkub4=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall
    mkdir --parents $out/bin
    install --mode=0755 openbsd_snmp3.py $out/bin
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = openbsd_snmp3_check;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/alexander-naumov/openbsd_snmp3_check/releases/tag/v${version}";
    description = "SNMP v3 check for OpenBSD systems state monitoring";
    homepage = "https://github.com/alexander-naumov/openbsd_snmp3_check";
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ jwillikers ];
    mainProgram = "openbsd_snmp3.py";
  };
}
