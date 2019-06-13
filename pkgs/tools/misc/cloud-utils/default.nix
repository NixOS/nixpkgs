{ stdenv, fetchurl, makeWrapper
, gawk, gnused, utillinux, file
, wget, python3, qemu, euca2ools
, e2fsprogs, cdrkit }:

stdenv.mkDerivation rec {
  # NOTICE: if you bump this, make sure to run
  # $ nix-build nixos/release-combined.nix -A nixos.tests.ec2-nixops
  # growpart is needed in initrd in nixos/system/boot/grow-partition.nix
  name = "cloud-utils-${version}";
  version = "0.30";
  src = fetchurl {
    url = "https://launchpad.net/cloud-utils/trunk/0.3/+download/cloud-utils-${version}.tar.gz";
    sha256 = "19ca9ckwwsvlqrjz19bc93rq4gv3y4ak7551li2qk95caqyxsq3k";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];
  installFlags = [ "LIBDIR=$(out)/lib" "BINDIR=$(out)/bin" "MANDIR=$(out)/man/man1" "DOCDIR=$(out)/doc" ];

  # according to https://packages.ubuntu.com/source/zesty/cloud-utils
  binDeps = [
    wget e2fsprogs file gnused gawk utillinux qemu euca2ools cdrkit
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
