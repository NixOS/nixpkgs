{stdenv, fetchurl, pkgconfig, libusb, readline, lua, libewf, perl,
gtk ? null, vte ? null, gtkdialog ? null,
python ? null,
ruby ? null,
useX11, rubyBindings, pythonBindings, luaBindings}:

assert useX11 -> (gtk != null && vte != null && gtkdialog != null);
assert rubyBindings -> ruby != null;
assert pythonBindings -> python != null;

let 
  optional = stdenv.lib.optional;
in
stdenv.mkDerivation rec {
  name = "radare-1.5";

  src = fetchurl {
    url = "http://radare.org/get/${name}.tar.gz";
    sha256 = "1r0c9cc7z9likma8zicp2pbv2y85vjjmnk0k45wdhbvhgqh6il1h";
  };


  buildInputs = [pkgconfig readline libusb libewf perl]
    ++ optional useX11 [gtkdialog vte gtk]
    ++ optional rubyBindings [ruby]
    ++ optional pythonBindings [python]
    ++ optional luaBindings [lua];

  meta = {
    description = "Free advanced command line hexadecimal editor";
    homepage = http://radare.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
