{ stdenv, lib, fetchurl, json_c, libbsd }:

stdenv.mkDerivation rec {
  pname = "health-check";
  version = "0.03.04";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0p85ai31n9hh6d4b79zzlczf9arsy7vmkjak1x3g9f5qj8fy4avp";
  };

  buildInputs = [ json_c libbsd ];

  makeFlags = [ "JSON_OUTPUT=y" "FNOTIFY=y" ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];

  meta = with lib; {
    description = "Process monitoring tool";
    homepage = "https://kernel.ubuntu.com/~cking/health-check/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
