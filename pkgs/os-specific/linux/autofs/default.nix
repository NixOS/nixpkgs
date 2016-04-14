{ stdenv, fetchurl, flex, bison, linuxHeaders, libxml2, kerberos, kmod,
  openldap, sssd, cyrus_sasl, openssl }:

let
  version = "5.1.1";
  name = "autofs-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kernel/linux/daemons/autofs/v5/${name}.tar.xz";
    sha256 = "1hr1f11wp538h7r298wpa5khfkhfs8va3p1kdixxhrgkkzpz13z0";
  };

  preConfigure = ''
    configureFlags="--disable-move-mount --with-path=$PATH --with-openldap=${openldap} --with-sasl=${cyrus_sasl}"
    export sssldir="${sssd}/lib/sssd/modules"
    export HAVE_SSS_AUTOFS=1
    export MOUNT=/var/run/current-system/sw/bin/mount
    export UMOUNT=/var/run/current-system/sw/bin/umount
    export MODPROBE=/var/run/current-system/sw/bin/modprobe
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

  buildInputs = [ flex bison linuxHeaders libxml2 kerberos kmod openldap sssd
                  openssl cyrus_sasl ];

  meta = {
    inherit version;
    description = "Kernel-based automounter";
    homepage = http://www.linux-consulting.com/Amd_AutoFS/autofs.html;
    license = stdenv.lib.licenses.gpl2;
    executables = [ "automount" ];
  };
}
