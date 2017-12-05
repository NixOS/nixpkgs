{stdenv, fetchFromGitHub, fetchurl, fetchpatch, pkgconfig, libusb, readline, libewf, perl, zlib, openssl,
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
  version = "2.0.1";
  name = "radare2-${version}";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    sha256 = "031ndvinsypagpkdszxjq0hj91ijq9zx4dzk53sz7il7s3zn65c7";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-15385.patch";
      url = https://github.com/radare/radare2/commit/21a6f570ba33fa9f52f1bba87f07acc4e8c178f4.patch;
      sha256 = "19qg5j9yr5r62nrq2b6mscxsz0wyyfah2z5jz8dvj9kqxq186d43";
    })
  ];

  postPatch = let
    cs_ver = "3.0.4"; # version from $sourceRoot/shlr/Makefile
    capstone = fetchurl {
      url = "https://github.com/aquynh/capstone/archive/${cs_ver}.tar.gz";
      sha256 = "1whl5c8j6vqvz2j6ay2pyszx0jg8d3x8hq66cvgghmjchvsssvax";
    };
  in ''
    if ! grep -F "CS_VER=${cs_ver}" shlr/Makefile; then echo "CS_VER mismatch"; exit 1; fi
    substituteInPlace shlr/Makefile --replace CS_RELEASE=0 CS_RELEASE=1
    cp ${capstone} shlr/capstone-${cs_ver}.tar.gz

  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ readline libusb libewf perl zlib openssl]
    ++ optional useX11 [gtkdialog vte gtk2]
    ++ optional rubyBindings [ruby]
    ++ optional pythonBindings [python]
    ++ optional luaBindings [lua];

  postInstall = ''
    # replace symlinks pointing into the build directory with the files they point to
    rm $out/bin/{r2-docker,r2-indent}
    cp sys/r2-docker.sh $out/bin/r2-docker
    cp sys/indent.sh    $out/bin/r2-indent
  '';

  meta = {
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = http://radare.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [raskin makefu];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
