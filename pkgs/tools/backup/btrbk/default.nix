{ lib, stdenv, fetchurl, bash, btrfs-progs, openssh, perl, perlPackages
, util-linux, asciidoc, asciidoctor, mbuffer, makeWrapper, nixosTests }:

stdenv.mkDerivation rec {
  pname = "btrbk";
  version = "0.29.1";

  src = fetchurl {
    url = "https://digint.ch/download/btrbk/releases/${pname}-${version}.tar.xz";
    sha256 = "153inyvvnl17hq1w3nsa783havznaykdam2yrj775bmi2wg6fvwn";
  };

  nativeBuildInputs = [ asciidoc asciidoctor makeWrapper ];

  buildInputs = with perlPackages; [ perl DateCalc ];

  preInstall = ''
    for f in $(find . -name Makefile); do
      substituteInPlace "$f" \
        --replace "/usr" "$out" \
        --replace "/etc" "$out/etc"
    done

    # Tainted Mode disables PERL5LIB
    substituteInPlace btrbk --replace "perl -T" "perl"

    # Fix SSH filter script
    sed -i '/^export PATH/d' ssh_filter_btrbk.sh
    substituteInPlace ssh_filter_btrbk.sh --replace logger ${util-linux}/bin/logger
  '';

  preFixup = ''
    wrapProgram $out/sbin/btrbk \
      --set PERL5LIB $PERL5LIB \
      --prefix PATH ':' "${lib.makeBinPath [ btrfs-progs bash mbuffer openssh ]}"
  '';

  passthru.tests.btrbk = nixosTests.btrbk;

  meta = with lib; {
    description = "A backup tool for btrfs subvolumes";
    homepage = "https://digint.ch/btrbk";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ asymmetric ];
  };
}
