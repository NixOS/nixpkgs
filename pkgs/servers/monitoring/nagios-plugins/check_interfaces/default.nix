{
  check_interfaces,
  fetchurl,
  lib,
  net-snmp,
  nix-update-script,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "check_interfaces";
  version = "1.4.4";

  src = fetchurl {
    url = "https://github.com/NETWAYS/check_interfaces/releases/download/v${version}/check_interfaces-${version}.tar.gz";
    hash = "sha256-sQ2lee2gxyrl455tumMJ4EbKc8mYEDXl18Wik6daf5Q=";
  };

  buildInputs = [ net-snmp ];

  configureFlags = [ "--libexecdir=${placeholder "out"}/bin" ];

  enableParallelBuilding = true;

  postInstall = ''
    # Remove unnecessary header files
    rm --recursive $out/include
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = check_interfaces;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/NETWAYS/check_interfaces/releases/tag/v${version}";
    description = "Icinga check plugin for network hardware interfaces";
    homepage = "https://github.com/NETWAYS/check_interfaces/";
    license = with licenses; [ gpl2Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ jwillikers ];
    mainProgram = "check_interfaces";
  };
}
