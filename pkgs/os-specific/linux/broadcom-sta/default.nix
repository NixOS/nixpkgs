{ stdenv, fetchurl, kernel }:

let
  version = "6.30.223.271";
  hashes = {
    i686-linux   = "1kaqa2dw3nb8k23ffvx46g8jj3wdhz8xa6jp1v3wb35cjfr712sg";
    x86_64-linux = "1gj485qqr190idilacpxwgqyw21il03zph2rddizgj7fbd6pfyaz";
  };

  arch = stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") "_64";
  tarballVersion = stdenv.lib.replaceStrings ["."] ["_"] version;
  tarball = "hybrid-v35${arch}-nodebug-pcoem-${tarballVersion}.tar.gz";
in
stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";

  src = fetchurl {
    url = "https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/${tarball}";
    sha256 = hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [
    ./i686-build-failure.patch
    ./license.patch
    ./linux-4.7.patch
    # source: https://git.archlinux.org/svntogit/community.git/tree/trunk/004-linux48.patch?h=packages/broadcom-wl-dkms
    ./linux-4.8.patch
    # source: https://aur.archlinux.org/cgit/aur.git/tree/linux411.patch?h=broadcom-wl
    ./linux-4.11.patch
    # source: https://aur.archlinux.org/cgit/aur.git/tree/linux412.patch?h=broadcom-wl
    ./linux-4.12.patch
    ./linux-4.15.patch
    ./null-pointer-fix.patch
    ./gcc.patch
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
    maintainers = with stdenv.lib.maintainers; [ phreedom ];
    platforms = stdenv.lib.platforms.linux;
  };
}
