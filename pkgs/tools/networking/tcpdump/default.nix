{ stdenv, fetchurl, libpcap, perl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tcpdump";
  version = "4.9.3";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "0434vdcnbqaia672rggjzdn4bb8p8dchz559yiszzdk0sjrprm1c";
  };

  patches = [
    # Patch for CVE-2020-8037
    (fetchpatch {
      url = "https://github.com/the-tcpdump-group/tcpdump/commit/32027e199368dad9508965aae8cd8de5b6ab5231.patch";
      sha256 = "sha256-bO3aV032ru9+M/9isBRjmH8jTZLKj9Zf9ha2rmOaZwc=";
    })
  ];

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
    homepage = "http://www.tcpdump.org/";
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
