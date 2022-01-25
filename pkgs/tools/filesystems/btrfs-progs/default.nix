{ lib, stdenv, fetchurl
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxslt, pkg-config, python3, xmlto
, zstd
, acl, attr, e2fsprogs, libuuid, lzo, systemd, zlib
, runCommand, btrfs-progs
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "5.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "0cqqlcq9bywfi3cpg5ivxiv7p9v6z1r6k4nnmin24mj1kp8krarq";
  };

  nativeBuildInputs = [
    pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt
    python3 python3.pkgs.setuptools
  ];

  buildInputs = [ acl attr e2fsprogs libuuid lzo python3 zlib zstd ] ++ lib.optionals stdenv.hostPlatform.isGnu [ systemd ];

  # for python cross-compiling
  _PYTHON_HOST_PLATFORM = stdenv.hostPlatform.config;

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/share/bash-completion/completions/btrfs
  '';

  configureFlags = lib.optional stdenv.hostPlatform.isMusl "--disable-backtrace --disable-libudev";

  makeFlags = lib.optionals stdenv.hostPlatform.isGnu [ "udevruledir=$(out)/lib/udev/rules.d" ];

  enableParallelBuilding = true;

  passthru.tests = {
    simple-filesystem = runCommand "btrfs-progs-create-fs" {} ''
      mkdir -p $out
      truncate -s110M $out/disc
      ${btrfs-progs}/bin/mkfs.btrfs $out/disc | tee $out/success
      ${btrfs-progs}/bin/btrfs check $out/disc | tee $out/success
      [ -e $out/success ]
    '';
  };
  meta = with lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = "https://btrfs.wiki.kernel.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
