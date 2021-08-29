{ lib
, stdenv
, fetchurl
, installShellFiles
, python3
}:

stdenv.mkDerivation rec {
  pname = "flawfinder";
  version = "2.0.15";

  src = fetchurl {
    url = "https://dwheeler.com/flawfinder/flawfinder-${version}.tar.gz";
    sha256 = "01j4szy8gwvikrfzfayfayjnc1za0jxsnxp5fsa6d06kn69wyr8a";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ${pname} $out/bin
    installManPage flawfinder.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to examines C/C++ source code for security flaws";
    homepage = "https://dwheeler.com/flawfinder/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
