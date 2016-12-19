{ stdenv, fetchurl, lockfileProgs, perl, mimeConstruct }:

stdenv.mkDerivation rec {
  _name   = "logcheck";
  version = "1.3.17";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/${_name}/${_name}_${version}.tar.xz";
    sha256 = "0fphzaljc9ddv1x6l3zdf9cbarqgzpdqaqwm3plmarcc7qrgrly2";
  };

  preConfigure = ''
    substituteInPlace src/logtail --replace "/usr/bin/perl" "${perl}/bin/perl"
    substituteInPlace src/logtail2 --replace "/usr/bin/perl" "${perl}/bin/perl"

    sed -i -e 's|! -f /usr/bin/lockfile|! -f ${lockfileProgs}/bin/lockfile|' \
           -e 's|^\([ \t]*\)lockfile-|\1${lockfileProgs}/bin/lockfile-|' \
           -e "s|/usr/sbin/logtail2|$out/sbin/logtail2|" \
           -e 's|mime-construct|${mimeConstruct}/bin/mime-construct|' \
           -e 's|\$(run-parts --list "\$dir")|"$dir"/*|' src/logcheck
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "SBINDIR=sbin"
    "BINDIR=bin"
    "SHAREDIR=share/logtail/detectrotate"
 ];

  meta = {
    description = "Mails anomalies in the system logfiles to the administrator";
    longDescription = ''
      Mails anomalies in the system logfiles to the administrator.

      Logcheck helps spot problems and security violations in your logfiles automatically and will send the results to you by e-mail.
      Logcheck was part of the Abacus Project of security tools, but this version has been rewritten.
    '';
    homepage = http://logcheck.org;
    license = stdenv.lib.licenses.gpl2;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
