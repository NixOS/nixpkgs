{stdenv, fetchsvn, openssl, dbus, autoconf, automake, pkgconfig, dbus_glib}:

stdenv.mkDerivation {
    name = "disnix-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/disnix/trunk;
	md5 = "7b342fa667740b089e4a51bba62312e6";
	rev = 12590;
    };
    
    preConfigure = "./bootstrap";
    buildInputs = [ openssl dbus autoconf automake pkgconfig dbus_glib ];
    
    meta = {
	license = "LGPL";
    };
}