{ stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  name = "openresolv-3.5.7";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/openresolv/${name}.tar.bz2";
    sha256 = "14n51wqnh49zdvx11l79s3fh1jhg7kg9cfny5vk7zsix78spmyx7";
  };

  buildInputs = [ makeWrapper ];

  configurePhase =
    ''
      cat > config.mk <<EOF
      PREFIX=$out
      SYSCONFDIR=/etc
      SBINDIR=$out/sbin
      LIBEXECDIR=$out/libexec/resolvconf
      VARDIR=/var/run/resolvconf
      MANDIR=$out/share/man
      RESTARTCMD="false \1"
      EOF
    '';

  installFlags = "SYSCONFDIR=$(out)/etc";

  postInstall = ''
    wrapProgram "$out/sbin/resolvconf" --set PATH "${coreutils}/bin"
  '';

  meta = {
    description = "A program to manage /etc/resolv.conf";
    homepage = http://roy.marples.name/projects/openresolv;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
