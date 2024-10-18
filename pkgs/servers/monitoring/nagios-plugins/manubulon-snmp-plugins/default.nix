{
  fetchFromGitHub,
  lib,
  makeWrapper,
  manubulon-snmp-plugins,
  nix-update-script,
  perlPackages,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "manubulon-snmp-plugins";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "SteScho";
    repo = "manubulon-snmp";
    rev = "v${version}";
    sha256 = "sha256-I4wKAy704ddoseb7NFBj7+O7l1Sy2JItoe6wrBUaJRQ=";
  };

  buildInputs = with perlPackages; [
    CryptDES
    CryptRijndael
    DigestHMAC
    GetoptLongDescriptive
    NetSNMP
    perl
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir --parents $out/bin
    install --mode=0755 plugins/*.pl $out/bin
    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/* ; do
      wrapProgram $f --set PERL5LIB $PERL5LIB --set LC_ALL C
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = manubulon-snmp-plugins;
      # Program returns status code 3
      command = "check_snmp_int.pl --version || true";
      version = "check_snmp_int version : ${version}";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/SteScho/manubulon-snmp/releases/tag/v${version}";
    description = "Set of Icinga/Nagios plugins to check hosts and hardware with the SNMP protocol";
    homepage = "https://github.com/SteScho/manubulon-snmp";
    license = with licenses; [ gpl2Only ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jwillikers ];
  };
}
