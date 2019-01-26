{ stdenv, fetchurl, coreutils, bash, btrfs-progs, openssh, perl, perlPackages
, utillinux, asciidoc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "btrbk-${version}";
  version = "0.27.1";

  src = fetchurl {
    url = "https://digint.ch/download/btrbk/releases/${name}.tar.xz";
    sha256 = "040f6qzv188yd38n11zdiin3gaavrlld36xf1ks4hxhq921bh0jc";
  };

  nativeBuildInputs = [ asciidoc makeWrapper ];

  buildInputs = with perlPackages; [ perl DateCalc ];

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

    # Fix SSH filter script
    sed -i '/^export PATH/d' ssh_filter_btrbk.sh
    substituteInPlace ssh_filter_btrbk.sh --replace logger ${utillinux}/bin/logger
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
