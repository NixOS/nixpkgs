{ stdenv, fetchurl, automake, autoconf, libtool, fuse, pkgconfig, pcre,

# Optional Dependencies
lz4 ? null, xz ? null, zlib ? null, lzo ? null, zstd ? null}:

with stdenv.lib;
let
  mkFlag = trueStr: falseStr: cond: name: val: "--"
    + (if cond then trueStr else falseStr)
    + name
    + optionalString (val != null && cond != false) "=${val}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "--without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  optLz4 = shouldUsePkg lz4;
  optLzma = shouldUsePkg xz;
  optZlib = shouldUsePkg zlib;
  optLzo = shouldUsePkg lzo;
	optZstd = shouldUsePkg zstd;
in

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.101";
  name = "${pname}-${version}";

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = https://github.com/vasi/squashfuse;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux ++ platforms.darwin;
    license = "BSD-2-Clause";
  };

	src = fetchurl {
	    url = "https://github.com/vasi/squashfuse/archive/${version}.tar.gz";
	    sha256 = "08d1j1a73dhhypbk0q20qkrz564zpmvkpk3k3s8xw8gd9nvy2xa2";
	  };

  nativeBuildInputs = [ automake autoconf libtool pkgconfig];
  buildInputs = [ optLz4 optLzma optZlib optLzo optZstd fuse ];

	# We can do it far better i guess, ignoring -with option
	# but it should be safer like that.
	# TODO: Improve writing nix expression mkWithLib.
  configureFlags = [
    (mkWith (optLz4  != null) "lz4=${lz4}/lib"  null)
    (mkWith (optLzma != null) "xz=${xz}/lib" null)
    (mkWith (optZlib != null) "zlib=${zlib}/lib" null)
    (mkWith (optLzo  != null) "lzo=${lzo}/lib"  null)
		(mkWith (optZstd != null) "zstd=${zstd}/lib"  null)
  ];

  preConfigure = ''
    ./autogen.sh
  '';
}
