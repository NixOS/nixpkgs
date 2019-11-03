{ stdenv, fetchurl, coreutils, flex, bison, libelf, bc, hostname, perl }:


let  
  version = "5.3.8";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "0jb6yya9yx4z52p5m32dqj0kgc6aaz9df8mvq0hzy40bqb3czwvq";
  };
  config = ./zmalllinugz.config;

in
stdenv.mkDerivation rec {
  pname = "zmalllinugz";
  inherit version;

  srcs = [ src config ];

  dontConfigure = true;
  buildInputs = [ coreutils flex bison libelf bc hostname perl];
  
  unpackPhase = ''
    array=($srcs)
    kernel_tar_gz=''${array[0]}
    zmalllinugz_config=''${array[1]}
    tar -xf $kernel_tar_gz
    sourceRoot=linux-${version}
    cp $zmalllinugz_config $sourceRoot/.config

  '';

  makeFlags = [ "all" ];

  installPhase = ''
    mkdir -p $out/kernel 
    cp arch/x86/boot/bzImage $out/kernel
    cp .config $out/kernel
  '';

  meta = with stdenv.lib; {
    description = "Smallest possible linux kernel for KVM";
    longDescription = ''
      Did not find under Nixpkgs a better and simpler way to build a kernel for KVM that:
      * has all the modules to run as VM built-in
      * no initrd overhead
      * network support
      * easy filesystem sharing (9p)
      * nfs server/client support
      The existing Nix infrastructure to build linux kernel is to complex and time consuming to understand just to build a simple image
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ zokrezyl ];
    platforms = platforms.linux;
  };
}
