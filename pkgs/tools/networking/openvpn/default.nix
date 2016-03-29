{ stdenv, fetchpatch, fetchurl, iproute, lzo, openssl, pam, systemd, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openvpn-2.3.10";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "1xn8kv4v4h4v8mhd9k4s9rilb7k30jgb9rm7n4fwmfrm5swvbc7q";
  };

  patches = [
    # included in next release
    (fetchpatch {
      url = https://github.com/OpenVPN/openvpn/commit/9dfc2309c6b4143892137844197f5f84755f6580.patch;
      sha256 = "1mmqx5zjcb0kjaknzzklb8n07f4spx534bl07abnigvivvs4hca9";
    })
  ] ++ optional stdenv.isLinux ./systemd-notify.patch;

  buildInputs = [ lzo openssl pkgconfig ]
                  ++ optionals stdenv.isLinux [ pam systemd iproute ];

  configureFlags = ''
    --enable-password-save
  '' + optionalString stdenv.isLinux ''
    --enable-systemd
    --enable-iproute2
    IPROUTE=${iproute}/sbin/ip
  '';

  postInstall = ''
    mkdir -p $out/share/doc/openvpn/examples
    cp -r sample/sample-config-files/ $out/share/doc/openvpn/examples
    cp -r sample/sample-keys/ $out/share/doc/openvpn/examples
    cp -r sample/sample-scripts/ $out/share/doc/openvpn/examples
  '';

  enableParallelBuilding = true;

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lsystemd-daemon"; # hacky

  meta = {
    description = "A robust and highly flexible tunneling application";
    homepage = http://openvpn.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
