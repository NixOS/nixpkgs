{stdenv, fetchurl, flex, bison, linuxHeaders}:

let
  baseURL = mirror://kernel/linux/daemons/autofs/v5;
in
stdenv.mkDerivation {
  name = "autofs-5.0.8";

  src = fetchurl {
    url = "${baseURL}/autofs-5.0.8.tar.bz2";
    sha256 = "2e0e42c654b7762b1235ec0131317224c57fdc6757ec00c820b2aa86338c9f7d";
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
