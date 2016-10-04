{stdenv, fetchurl, pkgconfig, libusb, readline, libewf, perl, zlib, openssl,
gtk2 ? null, vte ? null, gtkdialog ? null,
python ? null,
ruby ? null,
lua ? null,
useX11, rubyBindings, pythonBindings, luaBindings}:

assert useX11 -> (gtk2 != null && vte != null && gtkdialog != null);
assert rubyBindings -> ruby != null;
assert pythonBindings -> python != null;

let
  optional = stdenv.lib.optional;
in
stdenv.mkDerivation rec {
  version = "0.10.6";
  name = "radare2-${version}";

  src = fetchurl {
    url = "http://radare.org/get/${name}.tar.xz";
    sha256 = "0icxd8zilygnggxc50lkk6jmcq8xl66rqxqhzqwpiprbn8k7b24f";
  };


  buildInputs = [pkgconfig readline libusb libewf perl zlib openssl]
    ++ optional useX11 [gtkdialog vte gtk2]
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
