{stdenv, fetchFromGitHub
, src_info, callPackage
, ninja, meson , pkgconfig
, libusb, readline, libewf, perl, zlib, openssl
, gtk2 ? null, vte ? null, gtkdialog ? null
, python ? null
, ruby ? null
, lua ? null
, useX11, rubyBindings, pythonBindings, luaBindings
}:

assert useX11 -> (gtk2 != null && vte != null && gtkdialog != null);
assert rubyBindings -> ruby != null;
assert pythonBindings -> python != null;


let
  inherit (stdenv.lib) optional;
in stdenv.mkDerivation (with src_info; rec {
  name = "radare2-${version}";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    inherit sha256;
  };

  postPatch = let
    capstone = fetchFromGitHub {
      owner = "aquynh";
      repo = "capstone";
      # version from $sourceRoot/shlr/Makefile
      rev = cs_tip;
      sha256 = cs_sha256;
    };
  in ''
    if ! grep -F "CS_TIP=${cs_tip}" shlr/Makefile; then echo "CS_TIP mismatch"; exit 1; fi
    # When using meson, it expects capstone source relative to build directory
    mkdir -p build/shlr
    ln -s ${capstone} build/shlr/capstone
  '';

  postInstall = ''
    ln -s $out/bin/radare2 $out/bin/r2
    install -D -m755 $src/binr/r2pm/r2pm $out/bin/r2pm
  '';

  mesonFlags = [
    "-Dr2_version_commit=${version_commit}"
    "-Dr2_gittap=${gittap}"
    "-Dr2_gittip=${gittip}"
    # 2.8.0 expects this, but later it becomes an option with default=false.
    "-Dcapstone_in_builddir=true"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ninja meson ];
  buildInputs = [ readline libusb libewf perl zlib openssl]
    ++ optional useX11 [gtkdialog vte gtk2]
    ++ optional rubyBindings [ruby]
    ++ optional pythonBindings [python]
    ++ optional luaBindings [lua];

  meta = {
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = http://radare.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [raskin makefu mic92];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
})

