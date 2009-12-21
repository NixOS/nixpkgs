args: with args;
let
  baseURL = mirror://kernel/linux/daemons/autofs/v5;

in
stdenv.mkDerivation {
  name = "autofs-5.0.4";

  # It's too tiresome to apply all patches which are availible (see previous rev).
  # Using git repo which seems to be the same anyway..
  # REGION AUTO UPDATE:    { name="autofs"; type="git"; url="http://ftp.riken.go.jp/Linux/kernel.org/scm/linux/storage/autofs/autofs.git"; }
  src= sourceFromHead "autofs-9a77464b8a661d33a6205756955e0047727d5c1f.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/autofs-9a77464b8a661d33a6205756955e0047727d5c1f.tar.gz"; sha256 = "6764390e1f202eaef2f800146c8ccef616d502cec9471b006abde0781a62237f"; });
  # END
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

  buildInputs = [flex bison linuxHeaders];

  meta = { 
    description="Kernel based automounter";
    homepage="http://www.linux-consulting.com/Amd_AutoFS/autofs.html";
    license = "GPLv2";
    executables = [ "automount" ];
  };
}
