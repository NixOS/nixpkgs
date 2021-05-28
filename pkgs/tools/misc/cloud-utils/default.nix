{ stdenv, fetchurl, makeWrapper
, gawk, gnused, utillinux, file
, wget, python3, qemu-utils, euca2ools
, e2fsprogs, cdrkit }:

stdenv.mkDerivation rec {
  # NOTICE: if you bump this, make sure to run
  # $ nix-build nixos/release-combined.nix -A nixos.tests.ec2-nixops
  # growpart is needed in initrd in nixos/system/boot/grow-partition.nix
  pname = "cloud-utils";
  version = "0.31";
  src = fetchurl {
    url = "https://launchpad.net/cloud-utils/trunk/${version}/+download/cloud-utils-${version}.tar.gz";
    sha256 = "07fl3dlqwdzw4xx7mcxhpkks6dnmaxha80zgs9f6wmibgzni8z0r";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];
  installFlags = [ "LIBDIR=$(out)/lib" "BINDIR=$(out)/bin" "MANDIR=$(out)/man/man1" "DOCDIR=$(out)/doc" ];

  # according to https://packages.ubuntu.com/source/zesty/cloud-utils
  binDeps = [
    wget e2fsprogs file gnused gawk utillinux qemu-utils euca2ools cdrkit
  ];

  postFixup = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PATH : "${stdenv.lib.makeBinPath binDeps}:$out/bin"
    done
  '';

  dontBuild = true;

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
