{stdenv, fetchurl, devicemapper, enableStatic ? true}:

assert enableStatic -> devicemapper.enableStatic;

stdenv.mkDerivation {
  name = "lvm2-2.02.39";
  
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.39.tgz;
    sha256 = "18nfy7lj9fjjqjjd9dmb4v8away7cpi51ss1k8gd0yrh77dbsyyh";
  };
  
  buildInputs = [devicemapper];

  inherit enableStatic;
  
  configureFlags = "--disable-readline ${if enableStatic then "--enable-static_link" else ""}";
  
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
