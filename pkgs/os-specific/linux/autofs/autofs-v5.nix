{stdenv, fetchurl, flex, bison, linuxHeaders}:

let
  baseURL = mirror://kernel/linux/daemons/autofs/v5;
in
stdenv.mkDerivation {
  name = "autofs-5.0.5";

  src = fetchurl {
    url = "${baseURL}/autofs-5.0.5.tar.bz2";
    sha256 = "00k0k3jkbr29gn1wnzqjyc9iqq5bwjyip1isc79wf51wph0kxiv8";
  };

  patches = import ./patches-v5.nix fetchurl;

  preConfigure = ''
    configureFlags="--with-path=$PATH"
    export MOUNT=/var/run/current-system/sw/bin/mount
    export UMOUNT=/var/run/current-system/sw/bin/umount
    export MODPROBE=/var/run/current-system/sw/sbin/modprobe
    # Grrr, rpcgen can't find cpp. (NIXPKGS-48)
    mkdir rpcgen
    echo "#! $shell" > rpcgen/rpcgen
    echo "exec $(type -tp rpcgen) -Y $(dirname $(type -tp cpp)) \"\$@\"" >> rpcgen/rpcgen
    chmod +x rpcgen/rpcgen
    export RPCGEN=$(pwd)/rpcgen/rpcgen
  '';

  installPhase = ''
    make install SUBDIRS="lib daemon modules man" # all but samples
    #make install SUBDIRS="samples" # impure!
  '';

  buildInputs = [flex bison linuxHeaders];

  meta = { 
    description="Kernel based automounter";
    homepage="http://www.linux-consulting.com/Amd_AutoFS/autofs.html";
    license = "GPLv2";
    executables = [ "automount" ];
  };
}
