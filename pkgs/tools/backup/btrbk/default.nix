{ lib
, stdenv
, fetchurl
, bash
, btrfs-progs
, openssh
, perl
, perlPackages
, util-linux
, asciidoctor
, mbuffer
, makeWrapper
, genericUpdater
, curl
, writeShellScript
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "btrbk";
  version = "0.32.5";

  src = fetchurl {
    url = "https://digint.ch/download/btrbk/releases/${pname}-${version}.tar.xz";
    sha256 = "8f5AkWgCFteMeQPYKn+P+V6Ypb6x0f/bK6UpOovDn7Q=";
  };

  nativeBuildInputs = [ asciidoctor makeWrapper ];

  buildInputs = with perlPackages; [ perl DateCalc ];

  preInstall = ''
    for f in $(find . -name Makefile); do
      substituteInPlace "$f" \
        --replace "/usr" "$out" \
        --replace "/etc" "$out/etc"
    done

    # Tainted Mode disables PERL5LIB
    substituteInPlace btrbk \
      --replace "perl -T" "perl" \
      --replace "\$0" "\$ENV{'program_name'}"

    # Fix SSH filter script
    sed -i '/^export PATH/d' ssh_filter_btrbk.sh
    substituteInPlace ssh_filter_btrbk.sh --replace logger ${util-linux}/bin/logger
  '';

  preFixup = ''
    wrapProgram $out/bin/btrbk \
      --set PERL5LIB $PERL5LIB \
      --run 'export program_name=$0' \
      --prefix PATH ':' "${lib.makeBinPath [ btrfs-progs bash mbuffer openssh ]}"
  '';

  passthru.tests = {
    inherit (nixosTests) btrbk btrbk-no-timer btrbk-section-order;
  };

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "btrbk-versionLister" ''
      ${curl}/bin/curl -s https://digint.ch/download/btrbk/releases/ | ${perl}/bin/perl -lne 'print $1 if /btrbk-([0-9.]*)\.tar/'
    '';
  };

  meta = with lib; {
    description = "A backup tool for btrfs subvolumes";
    homepage = "https://digint.ch/btrbk";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ asymmetric ];
  };
}
