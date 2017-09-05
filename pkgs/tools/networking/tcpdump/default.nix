{ stdenv, fetchFromGitHub, fetchpatch, libpcap, enableStatic ? false
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

  patches = [
    (fetchpatch {
      url = "http://www.tcpdump.org/pre-4.9.2/PUBLISHED-CVE-2017-11541.patch";
      sha256 = "1lqg4lbyddnv75wpj0rs2sxz4lb3d1vp8n385i27mrpcxw9qaxia";
    })
    (fetchpatch {
      url = "http://www.tcpdump.org/pre-4.9.2/PUBLISHED-CVE-2017-11542.patch";
      sha256 = "0vqgmw9i5vr3d4siyrh8mw60jdmp5r66rbjxfmbnwhlfjf4bwxz4";
    })
    (fetchpatch {
      url = "http://www.tcpdump.org/pre-4.9.2/PUBLISHED-CVE-2017-11543.patch";
      sha256 = "1vk9ncpx0qjja8l69xw5kkvgy9fkcii2n98diazv1yndln2cs26l";
    })
    (fetchpatch {
      url = "http://www.tcpdump.org/pre-4.9.2/PUBLISHED-OpenSSL-1.1-segfault.patch";
      sha256 = "0mw0jdj5nyg4sviqj7wxwf2492b2bdqmjrvf1k34ak417xfcvy1d";
    })
  ];

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
