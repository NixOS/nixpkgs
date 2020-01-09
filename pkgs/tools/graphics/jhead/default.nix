{ stdenv, fetchurl, fetchpatch, libjpeg }:

stdenv.mkDerivation rec {
  pname = "jhead";
  version = "3.03";

  src = fetchurl {
    url = "http://www.sentex.net/~mwandel/jhead/${pname}-${version}.tar.gz";
    sha256 = "1hn0yqcicq3qa20h1g313l1a671r8mccpb9gz0w1056r500lw6c2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-1010301.patch";
      url = "https://sources.debian.org/data/main/j/jhead/1:3.03-3/debian/patches/36_CVE-2019-1010301";
      sha256 = "1vvrg50z5y7sjhfi973wh1q1v79sqp7hk5d4z0dlnx3fqgkjrx7q";
    })
    (fetchpatch {
      name = "CVE-2019-1010302.patch";
      url = "https://sources.debian.org/data/main/j/jhead/1:3.03-3/debian/patches/37_CVE-2019-1010302";
      sha256 = "1h11mpsi7hpwbi8kpnkjwn6zpqf88f132h0rsg8sggcs3vva2x8y";
    })
  ];

  buildInputs = [ libjpeg ];

  patchPhase = ''
    substituteInPlace makefile \
      --replace /usr/local/bin $out/bin

    substituteInPlace jhead.c \
      --replace "\"   Compiled: \"__DATE__" "" \
      --replace "jpegtran -trim" "${libjpeg.bin}/bin/jpegtran -trim"
  '';

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/man/man1 \
      $out/share/doc/${pname}-${version}

    cp -v jhead $out/bin
    cp -v jhead.1 $out/man/man1
    cp -v *.txt $out/share/doc/${pname}-${version}
  '';

  meta = with stdenv.lib; {
    homepage = http://www.sentex.net/~mwandel/jhead/;
    description = "Exif Jpeg header manipulation tool";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
