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
  version = "1.3.0";
  name = "radare2-${version}";

  src = fetchurl {
    url = "http://cloud.radare.org/get/${version}/${name}.tar.gz";
    sha256 = "08p2vhv6vkqvknwq18xl5wgf843lbpbmb111x23gkkxm6vxvpydd";
  };


  buildInputs = [pkgconfig readline libusb libewf perl zlib openssl]
    ++ optional useX11 [gtkdialog vte gtk2]
    ++ optional rubyBindings [ruby]
    ++ optional pythonBindings [python]
    ++ optional luaBindings [lua];

  meta = {
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = http://radare.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [raskin makefu];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
