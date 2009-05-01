args: with args;
let
  baseURL = mirror://kernel/linux/daemons/autofs/v5;

in
stdenv.mkDerivation {
  name = "autofs-5.0.4";

  # It's too tiresome to apply all patches which are availible (see previous rev).
  # Using git repo which seems to be the same anyway..
  src = bleedingEdgeRepos.sourceByName "autofs";
  /*fetchurl {
    url = "${baseURL}/autofs-5.0.4.tar.bz2";
    sha256 = "06ysv24jwhwvl8vbafy4jxcg9ps1iq5nrz2nyfm6c761rniy27v3";
  };*/

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

  buildInputs = [flex bison kernelHeaders];

  meta = { 
    description="Kernel based automounter";
    homepage="http://www.linux-consulting.com/Amd_AutoFS/autofs.html";
    license = "GPLv2";
    executables = [ "automount" ];
  };
}
