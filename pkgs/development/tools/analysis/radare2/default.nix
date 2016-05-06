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
  version = "0.10.2";
  name = "radare2-${version}";

  src = fetchurl {
    url = "http://radare.org/get/${name}.tar.xz";
    sha256 = "0fzb9ck7a7rsxi9p5hc0d6dbihd5pd9jcm5w4iikdv3bbmpwxj8v";
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
