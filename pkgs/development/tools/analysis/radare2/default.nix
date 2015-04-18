{stdenv, fetchurl, pkgconfig, libusb, readline, libewf, perl, zlib, openssl,
gtk ? null, vte ? null, gtkdialog ? null,
python ? null,
ruby ? null,
lua ? null,
useX11, rubyBindings, pythonBindings, luaBindings}:

assert useX11 -> (gtk != null && vte != null && gtkdialog != null);
assert rubyBindings -> ruby != null;
assert pythonBindings -> python != null;

let 
  optional = stdenv.lib.optional;
in
stdenv.mkDerivation rec {
  version = "0.9.7";
  name = "radare2-${version}";

  src = fetchurl {
    url = "http://radare.org/get/${name}.tar.xz";
    sha256 = "01sdsnbvx1qzyradj03sg24rk2bi9x58m40r0aqj8skv92c87s7l";
  };


  buildInputs = [pkgconfig readline libusb libewf perl zlib openssl]
    ++ optional useX11 [gtkdialog vte gtk]
    ++ optional rubyBindings [ruby]
    ++ optional pythonBindings [python]
    ++ optional luaBindings [lua];

  meta = {
    description = "Free advanced command line hexadecimal editor";
    homepage = http://radare.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
