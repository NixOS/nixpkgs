{stdenv, fetchsvn, openssl, dbus, autoconf, automake, pkgconfig, dbus_glib}:

stdenv.mkDerivation {
    name = "disnix-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/disnix/trunk;
	md5 = "419b1fc443e08687874c79d7a09060a7";
	rev = 12275;
    };
    
    preConfigure = "./bootstrap";
    buildInputs = [ openssl dbus autoconf automake pkgconfig dbus_glib ];
    
    meta = {
	license = "LGPL";
    };
}