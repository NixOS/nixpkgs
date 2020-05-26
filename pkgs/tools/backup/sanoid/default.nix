{ lib, stdenv, fetchFromGitHub, fetchpatch, makeWrapper, coreutils, zfs
, perlPackages, procps, which, openssh, sudo, mbuffer, pv, lzop, gzip, pigz }:

with lib;

stdenv.mkDerivation rec {
  pname = "sanoid";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "jimsalterjrs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wmymzqg503nmhw8hrblfs67is1l3ljbk2fjvrqwyb01b7mbn80x";
  };

  patches = [
    # Make sanoid look for programs in PATH
    (fetchpatch {
      url = "https://github.com/jimsalterjrs/sanoid/commit/dc2371775afe08af799d3097d47b48182d1716eb.patch";
      sha256 = "16hlwcbcb8h3ar1ywd2bzr3h3whgbcfk6walmp8z6j74wbx81aav";
    })
    # Make findoid look for programs in PATH
    (fetchpatch {
      url = "https://github.com/jimsalterjrs/sanoid/commit/44bcd21f269e17765acd1ad0d45161902a205c7b.patch";
      sha256 = "0zqyl8q5sfscqcc07acw68ysnlnh3nb57cigjfwbccsm0zwlwham";
    })
    # Add --cache-dir option
    (fetchpatch {
      url = "https://github.com/jimsalterjrs/sanoid/commit/a1f5e4c0c006e16a5047a16fc65c9b3663adb81e.patch";
      sha256 = "1bb4g2zxrbvf7fvcgzzxsr1cvxzrxg5dzh89sx3h7qlrd6grqhdy";
    })
    # Add --run-dir option
    (fetchpatch {
      url = "https://github.com/jimsalterjrs/sanoid/commit/59a07f92b4920952cc9137b03c1533656f48b121.patch";
      sha256 = "11v4jhc36v839gppzvhvzp5jd22904k8xqdhhpx6ghl75yyh4f4s";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [ perl ConfigIniFiles CaptureTiny ];

  installPhase = ''
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
      --prefix PATH : "${makeBinPath [ procps "/run/booted-system/sw" zfs ]}"

    install -m755 syncoid "$out/bin/syncoid"
    wrapProgram "$out/bin/syncoid" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${makeBinPath [ openssh procps which pv mbuffer lzop gzip pigz "/run/booted-system/sw" zfs ]}"

    install -m755 findoid "$out/bin/findoid"
    wrapProgram "$out/bin/findoid" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${makeBinPath [ "/run/booted-system/sw" zfs ]}"
  '';

  meta = {
    description = "A policy-driven snapshot management tool for ZFS filesystems";
    homepage = "https://github.com/jimsalterjrs/sanoid";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
