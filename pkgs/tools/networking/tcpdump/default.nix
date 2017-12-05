{ stdenv, fetchFromGitHub, libpcap, enableStatic ? false
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "tcpdump-${version}";
  version = "4.9.1";

  src = fetchFromGitHub rec {
    owner = "the-tcpdump-group";
    repo = "tcpdump";
    rev = "${repo}-${version}";
    sha256 = "1vzrvn1q7x28h18yskqc390y357pzpg5xd3pzzj4xz3llnvsr64p";
  };

  buildInputs = [ libpcap ];

  crossAttrs = {
    LDFLAGS = if enableStatic then "-static" else "";
    configureFlags = [ "ac_cv_linux_vers=2" ] ++ (stdenv.lib.optional
      (hostPlatform.platform.kernelMajor == "2.4") "--disable-ipv6");
  };

  meta = {
    description = "Network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ mornfall jgeerds ];
    platforms = stdenv.lib.platforms.linux;
  };
}
