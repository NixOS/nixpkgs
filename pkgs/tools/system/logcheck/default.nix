{ stdenv, fetchurl, lockfileProgs, perl, mimeConstruct }:

stdenv.mkDerivation rec {
  name = "logcheck-${version}";
  version = "1.3.18";
  _name    = "logcheck_${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/logcheck/${_name}.tar.xz";
    sha256 = "1x4skb5nmv2xj8cygj8pq1rd1ws4m2fsibw54yslgdyjri4r2yq7";
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

  meta = with stdenv.lib; {
    description = "Mails anomalies in the system logfiles to the administrator";
    longDescription = ''
      Mails anomalies in the system logfiles to the administrator.

      Logcheck helps spot problems and security violations in your logfiles automatically and will send the results to you by e-mail.
      Logcheck was part of the Abacus Project of security tools, but this version has been rewritten.
    '';
    homepage = http://logcheck.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.bluescreen303 ];
    
  };
}
