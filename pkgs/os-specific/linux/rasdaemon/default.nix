{ lib, fetchgit, stdenv, perl, autoreconfHook, ... }:
stdenv.mkDerivation rec {
  pname = "rasdaemon";
  version = "0.6.7";

  src = fetchgit {
    url = "git://git.infradead.org/users/mchehab/rasdaemon.git";
    rev = "v${version}";
    sha256 = "sha256-vyUDwqDe+HD4mka6smdQuVSM5U9uMv/TrfHkyqVJMIo=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl ];
  postPatch = ''
    substituteInPlace util/ras-mc-ctl.in --replace @sysconfdir@ $out/etc
  '';
  configureFlags = [ "--sysconfdir=$(out)/etc" ];

  meta = with lib; {
    description = "a RAS (Reliability, Availability and Serviceability) logging tool";
    longDescription = ''
      Rasdaemon is a RAS (Reliability, Availability and
      Serviceability) logging tool. It records memory errors, using
      the EDAC tracing events. EDAC is a Linux kernel subsystem with
      handles detection of ECC errors from memory controllers for most
      chipsets on i386 and x86_64 architectures. EDAC drivers for
      other architectures like arm also exists.
    '';
    homepage = "https://git.infradead.org/users/mchehab/rasdaemon.git";
    maintainers = with maintainers; [ danderson ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
