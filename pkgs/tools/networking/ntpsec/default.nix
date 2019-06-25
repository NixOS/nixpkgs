{ stdenv, lib, fetchurl, 
  wafHook, pkgconfig, gnum4,
  asciidoc, libxslt, docbook_xsl,
  bison, openssl_1_1, libbsd,
  coreutils, pythonPackages, pps-tools,
  libcap ? null, libseccomp ? null,
}:

assert stdenv.isLinux -> libcap != null;
assert stdenv.isLinux -> libseccomp != null;

let
  python = pythonPackages.python;

  withSeccomp = stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64);
in

stdenv.mkDerivation rec {
  name = "ntpsec-${version}";
  version = "1.1.7";

  src = fetchurl {
    url = "https://ftp.ntpsec.org/pub/releases/ntpsec-${version}.tar.gz";
    sha256 = "12rrx8d6y52vp0ibiy9plvyn8w8c9cs4mhrv6whwrz1jv473xss8";
  };

  patches = [
    ./skip-decodenetnum-tests.patch
  ];

  preBuild = ''
    substituteInPlace ./ntpclients/ntpleapfetch \
      --replace cat ${coreutils}/bin/cat \
      --replace basename ${coreutils}/bin/basename \
      --replace chmod ${coreutils}/bin/chmod
  '';

  wafConfigureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--refclock=all"
    "--enable-leap-smear"
    "--python=${python}/bin/python"
  ]
    ++ stdenv.lib.optional withSeccomp "--enable-seccomp";


  nativeBuildInputs = [ pkgconfig wafHook gnum4
    asciidoc docbook_xsl libxslt
    python pythonPackages.wrapPython
  ];

  buildInputs = [ libbsd bison openssl_1_1 python ]
    ++ lib.optional withSeccomp libseccomp
    ++ lib.optionals stdenv.isLinux [ pps-tools libcap ];

  postFixup = ''
    wrapPythonPrograms
  '';

  hardeningEnable = [ "pie" ];

  meta = with stdenv.lib; {
    homepage = "https://www.ntpsec.org/";
    description = "A secure, hardened, and improved implementation of Network Time Protocol derived from NTP Classic";
    license = with licenses; [ cc-by-40 bsd2 bsd3 mit ntp ];
    maintainers = [ maintainers.georgyo ];
    platforms = platforms.linux;
  };
}
