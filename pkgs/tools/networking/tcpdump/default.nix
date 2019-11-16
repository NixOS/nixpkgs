{ stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  pname = "tcpdump";
  version = "4.9.3";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "0434vdcnbqaia672rggjzdn4bb8p8dchz559yiszzdk0sjrprm1c";
  };

  postPatch = ''
    patchShebangs tests
  '';

  checkInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = stdenv.lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "ac_cv_linux_vers=2";

  meta = {
    description = "Network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
