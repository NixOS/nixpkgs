{ stdenv, fetchurl, makeWrapper, autoconf, automake
, gnupg, perl, python, libmd, qprint, coreutils, gnused, glibc, gnupg1compat
, perlPackages }:

stdenv.mkDerivation rec {
  version = "2.5";
  basename = "signing-party";
  name = "${basename}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/s/${basename}/${basename}_${version}.orig.tar.gz";
    sha256 = "1y2bxk01qiwaqaily0s6zi10ssv7l35vksib6fxzyl76pp693nv2";
  };

  sourceRoot = ".";

  patches = [ ./gpgwrap_makefile.patch ];

  postPatch = ''
    substituteInPlace gpg-mailkeys/gpg-mailkeys --replace "/usr/sbin/sendmail" "sendmail"
  '';

  preBuild = ''
    substituteInPlace sig2dot/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace gpgsigs/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace keylookup/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace springgraph/Makefile --replace "\$(DESTDIR)/usr" "$out"
    substituteInPlace keyanalyze/Makefile --replace "\$(DESTDIR)/usr" "$out"
  '';

  nativeBuildInputs = [ autoconf automake makeWrapper ];
  buildInputs = [ gnupg perl python libmd ] ++
    (with perlPackages; [ GnuPGInterface TextTemplate MIMEtools NetIDNEncode MailTools ]);

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
    install -m 755 \
      caff/caff caff/pgp-clean caff/pgp-fixkey \
      gpglist/gpglist \
      gpgparticipants/gpgparticipants \
      gpgparticipants/gpgparticipants-prefill \
      gpgsigs/gpgsigs \
      gpg-key2ps/gpg-key2ps \
      gpg-mailkeys/gpg-mailkeys \
      keyart/keyart \
      $out/bin

    install -m 644 \
      caff/caff.1 caff/pgp-clean.1 caff/pgp-fixkey.1 \
      gpglist/gpglist.1 \
      gpgparticipants/gpgparticipants-prefill.1 \
      gpgparticipants/gpgparticipants.1 \
      gpgsigs/gpgsigs.1 \
      gpg-key2ps/gpg-key2ps.1 \
      gpg-mailkeys/gpg-mailkeys.1 \
      $out/share/man/man1

    wrapProgram $out/bin/caff --prefix PERL5LIB ":" "$PERL5LIB" \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg1compat ]}"
    wrapProgram $out/bin/gpg-mailkeys --prefix PATH ":" "${stdenv.lib.makeBinPath [ qprint coreutils gnused glibc gnupg1compat ]}"
  '';

  doCheck = false; # no tests

  meta = {
    description = "A collection for all kinds of pgp related things, including signing scripts, party preparation scripts etc";
    homepage = http://pgp-tools.alioth.debian.org;
    platforms = gnupg.meta.platforms;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
  };
}
