{ stdenv, fetchurl, coreutils, bash, btrfs-progs, openssh, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "btrbk-${version}";
  version = "0.24.0";

  src = fetchurl {
    url = "http://digint.ch/download/btrbk/releases/${name}.tar.xz";
    sha256 = "01jrlswly28h4q4r3qfrzadz0pf0ms6wynmqhwddj1ahj31729h3";
  };

  patches = [
    # https://github.com/digint/btrbk/pull/74
    ./btrbk-Prefix-PATH-instead-of-resetting-it.patch
  ];

  buildInputs = with perlPackages; [ makeWrapper perl DateCalc ];

  preInstall = ''
    substituteInPlace Makefile \
      --replace "/usr" "$out" \
      --replace "/etc" "$out/etc"

    # Tainted Mode disables PERL5LIB
    substituteInPlace btrbk --replace "perl -T" "perl"

    # Fix btrbk-mail
    substituteInPlace contrib/cron/btrbk-mail \
      --replace "/bin/date" "${coreutils}/bin/date" \
      --replace "/bin/echo" "${coreutils}/bin/echo" \
      --replace '$btrbk' 'btrbk'
  '';

  fixupPhase = ''
    patchShebangs $out/

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
