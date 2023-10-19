{ stdenv
, lib
, fetchurl
, fetchpatch
, ncurses
, perl
, help2man
, apparmorRulesFromClosure
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "inetutils";
  version = "2.4";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-F4nWsbGlff4qere1M+6fXf2cv1tZuxuzwmEu0I0PaLI=";
  };

  outputs = ["out" "apparmor"];

  patches = [
    # https://git.congatec.com/yocto/meta-openembedded/commit/3402bfac6b595c622e4590a8ff5eaaa854e2a2a3
    ./inetutils-1_9-PATH_PROCNET_DEV.patch
    (fetchpatch {
      name = "CVE-2023-40303.patch";
      url = "https://git.savannah.gnu.org/cgit/inetutils.git/patch/?id=e4e65c03f4c11292a3e40ef72ca3f194c8bffdd6";
      hash = "sha256-I5skN537owfpFpAZr4vDKPHuERI6+oq5/hFW2RQeUxI=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [ help2man perl /* for `whois' */ ];
  buildInputs = [ ncurses /* for `talk' */ libxcrypt ];

  # Don't use help2man if cross-compiling
  # https://lists.gnu.org/archive/html/bug-sed/2017-01/msg00001.html
  # https://git.congatec.com/yocto/meta-openembedded/blob/3402bfac6b595c622e4590a8ff5eaaa854e2a2a3/meta-networking/recipes-connectivity/inetutils/inetutils_1.9.1.bb#L44
  preConfigure = let
    isCross = stdenv.hostPlatform != stdenv.buildPlatform;
  in lib.optionalString isCross ''
    export HELP2MAN=true
  '';

  configureFlags = [ "--with-ncurses-include-dir=${ncurses.dev}/include" ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [ # Musl doesn't define rcmd
    "--disable-rcp"
    "--disable-rsh"
    "--disable-rlogin"
    "--disable-rexec"
  ] ++ lib.optional stdenv.isDarwin  "--disable-servers";

  doCheck = true;

  installFlags = [ "SUIDMODE=" ];

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.ping <<EOF
    $out/bin/ping {
      include <abstractions/base>
      include <abstractions/consoles>
      include <abstractions/nameservice>
      include "${apparmorRulesFromClosure { name = "ping"; } [stdenv.cc.libc]}"
      include <local/bin.ping>
      capability net_raw,
      network inet raw,
      network inet6 raw,
      mr $out/bin/ping,
    }
    EOF
  '';

  meta = with lib; {
    description = "Collection of common network programs";

    longDescription =
      '' The GNU network utilities suite provides the
         following tools: ftp(d), hostname, ifconfig, inetd, logger, ping, rcp,
         rexec(d), rlogin(d), rsh(d), syslogd, talk(d), telnet(d), tftp(d),
         traceroute, uucpd, and whois.
      '';

    homepage = "https://www.gnu.org/software/inetutils/";
    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };
}
