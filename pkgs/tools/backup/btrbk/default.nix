{ stdenv, fetchurl, coreutils, bash, btrfs-progs, openssh, perl, perlPackages
, asciidoc-full, makeWrapper }:

stdenv.mkDerivation rec {
  name = "btrbk-${version}";
  version = "0.26.1";

  src = fetchurl {
    url = "http://digint.ch/download/btrbk/releases/${name}.tar.xz";
    sha256 = "04ahfm52vcf1w0c2km0wdgj2jpffp45bpawczmygcg8fdcm021lp";
  };

  buildInputs = with perlPackages; [ asciidoc-full makeWrapper perl DateCalc ];

  preInstall = ''
    for f in $(find . -name Makefile); do
      substituteInPlace "$f" \
        --replace "/usr" "$out" \
        --replace "/etc" "$out/etc"
    done

    # Tainted Mode disables PERL5LIB
    substituteInPlace btrbk --replace "perl -T" "perl"

    # Fix btrbk-mail
    substituteInPlace contrib/cron/btrbk-mail \
      --replace "/bin/date" "${coreutils}/bin/date" \
      --replace "/bin/echo" "${coreutils}/bin/echo" \
      --replace '$btrbk' 'btrbk'
  '';

  preFixup = ''
    wrapProgram $out/sbin/btrbk \
      --set PERL5LIB $PERL5LIB \
      --prefix PATH ':' "${stdenv.lib.makeBinPath [ btrfs-progs bash openssh ]}"
  '';

  meta = with stdenv.lib; {
    description = "A backup tool for btrfs subvolumes";
    homepage = http://digint.ch/btrbk;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny ];
    inherit version;
  };
}
