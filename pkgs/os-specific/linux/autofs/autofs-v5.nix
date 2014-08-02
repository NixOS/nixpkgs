{stdenv, fetchurl, flex, bison, linuxHeaders}:

let
  baseURL = mirror://kernel/linux/daemons/autofs/v5;
in
stdenv.mkDerivation {
  name = "autofs-5.0.8";

  src = fetchurl {
    url = "${baseURL}/autofs-5.0.8.tar.bz2";
    sha256 = "0zczihrqdamj43401v2pczf7zi94f8qk20gc6l92nxmpak3443if";
  };

  patches = import ./patches-v5.nix fetchurl;

  preConfigure = ''
    configureFlags="--disable-move-mount --with-path=$PATH"
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
    license = stdenv.lib.licenses.gpl2;
    executables = [ "automount" ];
  };
}
