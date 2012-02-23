{ stdenv, fetchurl, kernel }:

let baseName = "frandom-1.1";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${kernel.version}";

  src = fetchurl {
    url = "http://sourceforge.net/projects/frandom/files/${baseName}.tar.gz";
    sha256 = "15rgyk4hfawqg7z1spk2xlk1nn6rcdls8gdhc70f91shrc9pvlls";
  };

  preBuild = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    substituteInPlace Makefile \
      --replace "\$(shell uname -r)" "$kernelVersion" \
      --replace "/lib/modules" "${kernel}/lib/modules"
  '';
 
  installPhase = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    ensureDir $out/lib/modules/$kernelVersion/misc
    cp frandom.ko $out/lib/modules/$kernelVersion/misc

    ensureDir $out/lib/udev/rules.d
    tee $out/lib/udev/rules.d/10-frandom.rules <<-EOF
    #
    # These are the rules for the frandom devices. In theory, we could let
    # udev's catch-all rule create the /dev node based upon the kernel name,
    # which gives correct result, except that the default MODE set in
    # 50-udev.rules (0600) is too restrictive.
    #
    KERNEL=="[ef]random", MODE="444", OPTIONS="last_rule"
    EOF
  '';

  buildInputs = [];

  meta = {
    description = "A very fast random number generator kernel module";
    homepage = http://frandom.sourceforge.net/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
  };
}

