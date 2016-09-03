{stdenv, fetchurl, pkgconfig, libusb, readline, lua, libewf, perl,
gtk ? null, vte ? null, gtkdialog ? null,
python ? null,
ruby ? null,
useX11, rubyBindings, pythonBindings, luaBindings}:

assert useX11 -> (gtk != null && vte != null && gtkdialog != null);
assert rubyBindings -> ruby != null;
assert pythonBindings -> python != null;

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "radare-1.5.2";

  src = fetchurl {
    url = "http://radare.org/get/${name}.tar.gz";
    sha256 = "1qdrmcnzfvfvqb27c7pknwm8jl2hqa6c4l66wzyddwlb8yjm46hd";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [pkgconfig readline libusb perl]
    ++ optional useX11 [gtkdialog vte gtk]
    ++ optional rubyBindings [ruby]
    ++ optional pythonBindings [python]
    ++ optional luaBindings [lua];

  meta = {
    description = "Free advanced command line hexadecimal editor";
    homepage = http://radare.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
