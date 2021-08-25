{ lib, stdenv, fetchFromGitHub, nixosTests, makeWrapper, zfs
, perlPackages, procps, which, openssh, mbuffer, pv, lzop, gzip, pigz }:

stdenv.mkDerivation rec {
  pname = "sanoid";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jimsalterjrs";
    repo = pname;
    rev = "v${version}";
    sha256 = "12g5cjx34ys6ix6ivahsbr3bbbi1fmjwdfdk382z6q71w3pyxxzf";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [ perl ConfigIniFiles CaptureTiny ];

  passthru.tests = nixosTests.sanoid;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/etc/sanoid"
    cp sanoid.defaults.conf "$out/etc/sanoid/sanoid.defaults.conf"
    # Hardcode path to default config
    substitute sanoid "$out/bin/sanoid" \
      --replace "\$args{'configdir'}/sanoid.defaults.conf" "$out/etc/sanoid/sanoid.defaults.conf"
    chmod +x "$out/bin/sanoid"
    # Prefer ZFS userspace tools from /run/booted-system/sw/bin to avoid
    # incompatibilities with the ZFS kernel module.
    wrapProgram "$out/bin/sanoid" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${lib.makeBinPath [ procps "/run/booted-system/sw" zfs ]}"

    install -m755 syncoid "$out/bin/syncoid"
    wrapProgram "$out/bin/syncoid" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${lib.makeBinPath [ openssh procps which pv mbuffer lzop gzip pigz "/run/booted-system/sw" zfs ]}"

    install -m755 findoid "$out/bin/findoid"
    wrapProgram "$out/bin/findoid" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${lib.makeBinPath [ "/run/booted-system/sw" zfs ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A policy-driven snapshot management tool for ZFS filesystems";
    homepage = "https://github.com/jimsalterjrs/sanoid";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
