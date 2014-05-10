{ stdenv, fetchurl, pkgconfig, perl, keyutils, nss, nspr, python, pam
, intltool, makeWrapper, coreutils, gettext, cryptsetup, lvm2, rsync, which }:

stdenv.mkDerivation {
  name = "ecryptfs-104";

  src = fetchurl {
    url = http://launchpad.net/ecryptfs/trunk/104/+download/ecryptfs-utils_104.orig.tar.gz;
    sha256 = "0f3lzpjw97vcdqzzgii03j3knd6pgwn1y0lpaaf46iidaiv0282a";
  };

  buildInputs = [ pkgconfig perl nss nspr python pam intltool makeWrapper ];
  propagatedBuildInputs = [ coreutils gettext cryptsetup lvm2 rsync keyutils which ];

  postInstall = ''
    FILES="$(grep -r '/bin/sh' $out/bin | sed 's,:.*,,' | uniq)"
    for file in $FILES; do
      sed -i $file -e "s,\(/sbin/u\?mount.ecryptfs\(_private\)\?\),$out\1," \
        -e "s,\(/sbin/cryptsetup\),${cryptsetup}\1," \
        -e "s,\(/sbin/dmsetup\),${lvm2}\1," \
        -e 's,/sbin/\(unix_chkpwd\),\1,'
      wrapProgram $file \
        --prefix PATH ":" "${coreutils}/bin" \
        --prefix PATH ":" "${gettext}/bin" \
        --prefix PATH ":" "${rsync}/bin" \
        --prefix PATH ":" "${keyutils}/bin" \
        --prefix PATH ":" "${which}/bin" \
        --prefix PATH ":" "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "Enterprise-class stacked cryptographic filesystem";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
