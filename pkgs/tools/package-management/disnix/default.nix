{stdenv, fetchsvn, openssl, dbus, autoconf, automake, pkgconfig, dbus_glib}:

stdenv.mkDerivation {
    name = "disnix-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/disnix/trunk;
	md5 = "f961fc6337151b89839eabedd0bc7d13";
	rev = 12332;
    };
    
    preConfigure = "./bootstrap";
    buildInputs = [ openssl dbus autoconf automake pkgconfig dbus_glib ];
    
    meta = {
	license = "LGPL";
    };
}