{stdenv, fetchurl, enableStatic ? true}:

stdenv.mkDerivation {
  name = "device-mapper-1.02.27";
  
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/dm/device-mapper.1.02.27.tgz;
    sha256 = "1z4dldjjxfinwvg39x4m2cm5rcsbxs833g3phm34f5a2lwh7i6v6";
  };

  inherit enableStatic;
  
  configureFlags = if enableStatic then "--enable-static_link" else "";

  # To prevent make install from failing.
  installFlags = "OWNER= GROUP=";
}
