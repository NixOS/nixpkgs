{ lib, stdenv, fetchsvn
, makeWrapper, pkg-config
, gawk, gnutls, libgcrypt, nettools, openresolv, perl
, opensslSupport ? false, openssl # Distributing this is a GPL violation.
}:

stdenv.mkDerivation {
  pname = "vpnc";
  version = "0.5.3-post-r550";
  src = fetchsvn {
    url = "https://svn.unix-ag.uni-kl.de/vpnc";
    rev = "550";
    sha256 = "0x4ckfv9lpykwmh28v1kyzz91y1j2v48fi8q5nsawrba4q0wlrls";
  };

  postUnpack = ''
    mv $sourceRoot/trunk/* $sourceRoot/.
    rm -r $sourceRoot/{trunk,branches,tags}
  '';

  patches = [ ./no_default_route_when_netmask.patch ];

  # The `etc/vpnc/vpnc-script' script relies on `which' and on
  # `ifconfig' as found in net-tools (not GNU Inetutils).
  propagatedBuildInputs = [ nettools ];

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!opensslSupport) pkg-config;
  buildInputs = [ libgcrypt perl ]
    ++ (if opensslSupport then [ openssl ] else [ gnutls ]);

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc/vpnc"
    "SCRIPT_PATH=$(out)/etc/vpnc/vpnc-script"
  ] ++ lib.optional opensslSupport "OPENSSL_GPL_VIOLATION=yes";

  postPatch = ''
    patchShebangs makeman.pl
  '';

  preConfigure = ''
    substituteInPlace "vpnc-script" \
      --replace "which" "type -P" \
      --replace "awk" "${gawk}/bin/awk" \
      --replace "/sbin/resolvconf" "${openresolv}/bin/resolvconf"

    substituteInPlace "config.c" \
      --replace "/etc/vpnc/vpnc-script" "$out/etc/vpnc/vpnc-script"
  '';

  postInstall = ''
    for i in "$out/{bin,sbin}/"*
    do
      wrapProgram $i --prefix PATH :  \
        "${nettools}/bin:${nettools}/sbin"
    done

    mkdir -p $out/share/doc/vpnc
    cp README nortel.txt ChangeLog $out/share/doc/vpnc/
  '';

  meta = with lib; {
    homepage = "https://www.unix-ag.uni-kl.de/~massar/vpnc/";
    description = "Virtual private network (VPN) client for Cisco's VPN concentrators";
    license = if opensslSupport then licenses.unfree else licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
