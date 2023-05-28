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

  # Hard-code program paths instead of using PATH lookups. Also, labels.d and
  # mainboard are for user-configurable data, so do not look for them in Nix
  # store.
  dmidecodeProgram = lib.getExe' dmidecode "dmidecode";
  modprobeProgram = lib.getExe' kmod "modprobe";
  postPatch = ''
    substituteInPlace src/util/edac-ctl.in \
      --replace-fail 'find_prog ("dmidecode")' "\"$dmidecodeProgram\"" \
      --replace-fail 'find_prog ("modprobe")  or exit (1)' "\"$modprobeProgram\"" \
      --replace-fail '"$sysconfdir/edac/labels.d"' '"/etc/edac/labels.d"' \
      --replace-fail '"$sysconfdir/edac/mainboard"' '"/etc/edac/mainboard"'
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
