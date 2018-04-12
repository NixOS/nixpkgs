{stdenv, fetchFromGitHub, fetchgit, fetchurl, fetchpatch, pkgconfig, libusb, readline, libewf, perl, zlib, openssl, git,
gtk2 ? null, vte ? null, gtkdialog ? null,
python ? null,
ruby ? null,
lua ? null,
useX11, rubyBindings, pythonBindings, luaBindings}:

assert useX11 -> (gtk2 != null && vte != null && gtkdialog != null);
assert rubyBindings -> ruby != null;
assert pythonBindings -> python != null;

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  version = "2.5.0";
  name = "radare2-${version}";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    sha256 = "07x94chkhpn3wgw4pypn35psxq370j6xwmhf1mh5z27cqkq7c2yd";
  };

  postPatch = let
    cs_tip = "4a1b580d069c82d60070d0869a87000db7cdabe2"; # version from $sourceRoot/shlr/Makefile
    capstone = fetchgit {
      url = "https://github.com/aquynh/capstone.git";
      rev = cs_tip;
      sha256 = "1b126npshdbwh5y7rafmb9w4dzlvxsf4ca6bx4zs2y7kbk48jyn8";
      leaveDotGit = true;
    };
  in ''
    if ! grep -F "CS_TIP=${cs_tip}" shlr/Makefile; then echo "CS_TIP mismatch"; exit 1; fi
    cp -r ${capstone} shlr/capstone
    chmod -R u+rw shlr/capstone
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig git ];
  buildInputs = [ readline libusb libewf perl zlib openssl]
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
