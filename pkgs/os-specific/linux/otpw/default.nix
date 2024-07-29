{ lib
, stdenv
, coreutils
, fetchurl
, libxcrypt
, pam
, procps
, unixtools
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "otpw";
  version = "1.5";

  src = fetchurl {
    url = "https://www.cl.cam.ac.uk/~mgk25/download/otpw-${version}.tar.gz";
    hash = "sha256-mKyjimHHcTZ3uW8kQmynBTSAwP0HfZGx6ZvJ+SzLgyo=";
  };

  patchPhase = ''
    sed -i 's/^CFLAGS.*/CFLAGS=-O2 -fPIC/' Makefile
    substituteInPlace otpw-gen.c \
      --replace "head -c 20 /dev/urandom 2>&1" "${coreutils}/bin/head -c 20 /dev/urandom 2>&1" \
      --replace "ls -lu /etc/. /tmp/. / /usr/. /bin/. /usr/bin/." "${coreutils}/bin/ls -lu /etc/. /tmp/. / /usr/. /bin/. /usr/bin/." \
      --replace "PATH=/usr/ucb:/bin:/usr/bin;ps lax" "PATH=/usr/ucb:/bin:/usr/bin;${unixtools.procps}/bin/ps lax" \
      --replace "last | head -50" "${util-linux}/bin/last | ${coreutils}/bin/head -50" \
      --replace "uptime;netstat -n;hostname;date;w" "${coreutils}/bin/uptime; ${unixtools.nettools}/bin/netstat -n; ${unixtools.nettools}/bin/hostname; ${coreutils}/bin/date; ${procps}/bin/w"
  '';

  buildInputs = [
    libxcrypt
    pam
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/security $out/share/man/man{1,8}
    cp pam_*.so $out/lib/security
    cp otpw-gen $out/bin
    cp *.1 $out/share/man/man1
    cp *.8 $out/share/man/man8
  '';

  hardeningDisable = [
    "stackprotector"
  ];

  meta = with lib; {
    description = "One-time password login package";
    mainProgram = "otpw-gen";
    homepage = "http://www.cl.cam.ac.uk/~mgk25/otpw.html";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
