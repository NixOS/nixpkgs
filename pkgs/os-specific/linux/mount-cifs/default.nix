{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mount.cifs";
  
  src = fetchurl {
    name = "mount.cifs.c";
    url = "http://websvn.samba.org/cgi-bin/viewcvs.cgi/*checkout*/branches/SAMBA_3_0/source/client/mount.cifs.c?rev=6103";
    sha256 = "19205gd3pv8g519hlbjaw559wqgf0h2vkln9xgqaqip2h446qarp";
  };
 
  buildCommand = ''
    ensureDir $out/sbin
    gcc -Wall $src -o $out/sbin/mount.cifs
  '';
}
