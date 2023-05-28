{ lib, stdenv, fetchFromGitHub, perl, makeWrapper
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

  nativeBuildInputs = [ perl makeWrapper ];
  buildInputs = [ sysfsutils ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  postInstall = ''
    wrapProgram "$out/sbin/edac-ctl" \
      --set PATH ${lib.makeBinPath [ dmidecode kmod ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/grondo/edac-utils";
    description = "Handles the reporting of hardware-related memory errors";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
