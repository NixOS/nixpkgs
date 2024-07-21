{ lib
, stdenv
, fetchFromGitHub
, python3
, smartmontools
}:

stdenv.mkDerivation rec {
  pname = "check_smartmon";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner  = "driehuis";
    repo   = "Nagios_check_smartmon";
    rev    = version;
    sha256 = "tiIeFiHdDgqoeznk9XdCE7owIMnnsQ0fmtj8foFoUD8=";
  };

  buildInputs = [
    (python3.withPackages (pp: [ pp.psutil ]))
    smartmontools
  ];

  postPatch = ''
    patchShebangs check_smartmon.py
    substituteInPlace check_smartmon.py \
      --replace '"/usr/sbin/smartctl"' '"${smartmontools}/bin/smartctl"'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 755 check_smartmon.py $out/bin/check_smartmon
    runHook postInstall
  '';

  meta = with lib; {
    description = "Nagios-Plugin that uses smartmontools to check disk health status and temperature";
    mainProgram = "check_smartmon";
    homepage = "https://github.com/driehuis/Nagios_check_smartmon";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mariaa144 ];
  };
}
