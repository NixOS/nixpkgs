{ lib, stdenv, fetchurl, bash, btrfs-progs, openssh, perl, perlPackages
, util-linux, asciidoc, asciidoctor, mbuffer, makeWrapper, nixosTests }:

stdenv.mkDerivation rec {
  pname = "btrbk";
  version = "0.31.3";

  src = fetchurl {
    url = "https://digint.ch/download/btrbk/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-YvVJSWXdWU+BBl4boX+ZeNYDQ/cu517RjNoaNJzdp9M=";
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
    wrapProgram $out/bin/btrbk \
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
