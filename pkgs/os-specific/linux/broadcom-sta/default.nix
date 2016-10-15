{ stdenv, fetchurl, fetchpatch, kernel }:

let
  version = "6.30.223.271";
  hashes = {
    i686-linux   = "1kaqa2dw3nb8k23ffvx46g8jj3wdhz8xa6jp1v3wb35cjfr712sg";
    x86_64-linux = "1gj485qqr190idilacpxwgqyw21il03zph2rddizgj7fbd6pfyaz";
  };

  arch = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") "_64";
  tarballVersion = stdenv.lib.replaceStrings ["."] ["_"] version;
  tarball = "hybrid-v35${arch}-nodebug-pcoem-${tarballVersion}.tar.gz";
in
stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://www.broadcom.com/docs/linux_sta/${tarball}";
    sha256 = hashes."${stdenv.system}";
  };

  hardeningDisable = [ "pic" ];

  patches = [
    ./i686-build-failure.patch
    ./license.patch
    ./linux-4.7.patch
    ./null-pointer-fix.patch
    ./gcc.patch
    (fetchpatch {
      name = "linux-4.8.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/004-linux48.patch?h=broadcom-wl-dkms";
      sha256 = "0s8apf6l3qm9kln451g4z0pr13f4jdgyval1vfl2abg0dqc5xfhs";
    })
  ];

  makeFlags = "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}";

  unpackPhase = ''
    sourceRoot=broadcom-sta
    mkdir "$sourceRoot"
    tar xvf "$src" -C "$sourceRoot"
  '';

  installPhase = ''
    binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    docDir="$out/share/doc/broadcom-sta/"
    mkdir -p "$binDir" "$docDir"
    cp wl.ko "$binDir"
    cp lib/LICENSE.txt "$docDir"
  '';

  meta = {
    description = "Kernel module driver for some Broadcom's wireless cards";
    homepage = http://www.broadcom.com/support/802.11/linux_sta.php;
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = with stdenv.lib.maintainers; [ phreedom vcunat ];
    platforms = stdenv.lib.platforms.linux;
  };
}
