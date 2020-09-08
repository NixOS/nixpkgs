{ stdenv
, fetchurl
, coreutils
, bash
, btrfs-progs
, openssh
, perl
, perlPackages
, mbuffer
, makeWrapper
, buildPackages
, logger
, sudo
}:

stdenv.mkDerivation rec {
  pname = "btrbk";
  version = "0.29.1";

  src = fetchurl {
    url = "https://digint.ch/download/btrbk/releases/${pname}-${version}.tar.xz";
    sha256 = "153inyvvnl17hq1w3nsa783havznaykdam2yrj775bmi2wg6fvwn";
  };

  nativeBuildInputs = [ buildPackages.asciidoc buildPackages.asciidoctor makeWrapper ];

  buildInputs = [ bash ] ++ (with perlPackages; [ perl DateCalc ]);

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
      --prefix PATH ':' "${stdenv.lib.makeBinPath [ btrfs-progs bash mbuffer openssh ]}"
    substituteInPlace $out/sbin/btrbk --replace "${buildPackages.bash}" "${bash}"

    # Fix SSH filter script
    sed -i '/^export PATH/d' $out/share/btrbk/scripts/ssh_filter_btrbk.sh
    wrapProgram $out/share/btrbk/scripts/ssh_filter_btrbk.sh \
        --prefix PATH ':' "${stdenv.lib.makeBinPath [ btrfs-progs bash coreutils logger sudo ]}"
    substituteInPlace $out/share/btrbk/scripts/ssh_filter_btrbk.sh --replace "${buildPackages.bash}" "${bash}"
  '';

  meta = with stdenv.lib; {
    description = "A backup tool for btrfs subvolumes";
    homepage = "https://digint.ch/btrbk";
    changelog = "https://digint.ch/download/btrbk/releases/ChangeLog";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ asymmetric kampka ];
  };
}
