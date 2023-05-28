{ lib, stdenv, fetchFromGitHub, perl
, sysfsutils, dmidecode, kmod }:

stdenv.mkDerivation {
  pname = "edac-utils";
  version = "unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "grondo";
    repo = "edac-utils";
    rev = "8fdc1d40e30f65737fef6c3ddcd1d2cd769f6277";
    hash = "sha256-jZGRrZ1sa4x0/TBJ5GsNVuWakmPNOU+oiOoXdhARunk=";
  };

  patches = [ ./edac-ctl.patch ];
  postPatch = ''
    substituteInPlace src/util/edac-ctl.in \
      --subst-var-by dmidecode ${dmidecode}/bin/dmidecode \
      --subst-var-by modprobe ${kmod}/bin/modprobe
  '';

  nativeBuildInputs = [ perl ];
  buildInputs = [ perl sysfsutils ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  meta = with lib; {
    homepage = "https://github.com/grondo/edac-utils";
    description = "Handles the reporting of hardware-related memory errors";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
