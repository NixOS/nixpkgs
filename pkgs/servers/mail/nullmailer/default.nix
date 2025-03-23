{
  stdenv,
  fetchurl,
  lib,
  tls ? true,
  gnutls ? null,
}:

assert tls -> gnutls != null;

stdenv.mkDerivation rec {

  version = "2.2";
  pname = "nullmailer";

  src = fetchurl {
    url = "https://untroubled.org/nullmailer/nullmailer-${version}.tar.gz";
    sha256 = "0md8cf90fl2yf3zh9njjy42a673v4j4ygyq95xg7fzkygdigm1lq";
  };

  buildInputs = lib.optional tls gnutls;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ lib.optional tls "--enable-tls";

  installFlags = [ "DESTDIR=$(out)" ];

  # We have to remove the ''var'' directory, since nix can't handle named pipes
  # and we can't use it in the store anyway. Same for ''etc''.
  # The second line is need, because the installer of nullmailer will copy its
  # own prepared version of ''etc'' and ''var'' and also uses the prefix path (configure phase)
  # for hardcoded absolute references to its own binary farm, e.g. sendmail binary is
  # calling nullmailer-inject binary. Since we can't configure inside the store of
  # the derivation we need both directories in the root, but don't want to put them there
  # during install, hence we have to fix mumbling inside the install directory.
  # This is kind of a hack, but the only way I know of, yet.
  postInstall = ''
    rm -rf $out/var/ $out/etc/
    mv $out/$out/* $out/
    rmdir $out/$out
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://untroubled.org/nullmailer/";
    description = ''
      A sendmail/qmail/etc replacement MTA for hosts which relay to a fixed set of smart relays.
      It is designed to be simple to configure, secure, and easily extendable.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sargon ];
  };
}
