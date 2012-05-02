{stdenv, fetchurl, perl, cross ? null}:

assert cross == null -> stdenv.isLinux;

let version = "2.6.28.5"; in

stdenv.mkDerivation {
  name = "linux-headers-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
    sha256 = "0hifjh75sinifr5138v22zwbpqln6lhn65k8b57a1dyzlqca7cl9";
  };

  targetConfig = if (cross != null) then cross.config else null;

  platform =
    if cross != null then cross.arch else
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    if stdenv.isArm then "arm" else
    if stdenv.system == "mips64el-linux" then "mips" else
    abort "don't know what the kernel include directory is called for this platform";

  buildInputs = [perl];

  extraIncludeDirs =
    if cross != null then
	(if cross.arch == "powerpc" then ["ppc"] else [])
    else if stdenv.system == "powerpc-linux" then ["ppc"] else [];

  patchPhase = ''
    patch --verbose -p1 < "${./unifdef-getline.patch}"
    sed -i '/scsi/d' include/Kbuild
    sed -i 's|/ %/: prepare scripts FORCE|%/: prepare scripts FORCE|' Makefile
  '';

  buildPhase = ''
    if test -n "$targetConfig"; then
       export ARCH=$platform
    fi
    make mrproper headers_check
  '';

  installPhase = ''
    make INSTALL_HDR_PATH=$out headers_install

    # Some builds (e.g. KVM) want a kernel.release.
    mkdir -p $out/include/config
    echo "${version}-default" > $out/include/config/kernel.release
  '';

  # !!! hacky
  fixupPhase = ''
    ln -s asm $out/include/asm-$platform
    if test "$platform" = "i386" -o "$platform" = "x86_64"; then
      ln -s asm $out/include/asm-x86
    fi
  '';
}
