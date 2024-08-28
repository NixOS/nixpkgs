{ lib, stdenv, fetchurl, kernel }:

let
  version = "6.30.223.271";
  hashes = {
    i686-linux   = "sha256-T4twspOsjMXHDlca1dGHjQ8p0TOkb+eGmGjZwZtQWM0=";
    x86_64-linux = "sha256-X3l3TVvuyPdja1nA+wegMQju8eP9MkVjiyCFjHFBRL4=";
  };

  arch = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") "_64";
  tarballVersion = lib.replaceStrings ["."] ["_"] version;
  tarball = "hybrid-v35${arch}-nodebug-pcoem-${tarballVersion}.tar.gz";
in
stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";

  src = fetchurl {
    url = "https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/${tarball}";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [
    ./license.patch
    ./linux-4.7.patch
    # source: https://git.archlinux.org/svntogit/community.git/tree/trunk/004-linux48.patch?h=packages/broadcom-wl-dkms
    ./linux-4.8.patch
    # source: https://aur.archlinux.org/cgit/aur.git/tree/linux411.patch?h=broadcom-wl
    ./linux-4.11.patch
    # source: https://aur.archlinux.org/cgit/aur.git/tree/linux412.patch?h=broadcom-wl
    ./linux-4.12.patch
    ./linux-4.15.patch
    ./linux-5.1.patch
    # source: https://salsa.debian.org/Herrie82-guest/broadcom-sta/-/commit/247307926e5540ad574a17c062c8da76990d056f
    ./linux-5.6.patch
    # source: https://gist.github.com/joanbm/5c640ac074d27fd1d82c74a5b67a1290
    ./linux-5.9.patch
    # source: https://github.com/archlinux/svntogit-community/blob/33b4bd2b9e30679b03f5d7aa2741911d914dcf94/trunk/012-linux517.patch
    ./linux-5.17.patch
    # source: https://github.com/archlinux/svntogit-community/blob/2e1fd240f9ce06f500feeaa3e4a9675e65e6b967/trunk/013-linux518.patch
    ./linux-5.18.patch
    # source: https://gist.github.com/joanbm/207210d74637870c01ef5a3c262a597d
    ./linux-6.0.patch
    # source: https://gist.github.com/joanbm/94323ea99eff1e1d1c51241b5b651549
    ./linux-6.1.patch
    ./pedantic-fix.patch
    ./null-pointer-fix.patch
    ./gcc.patch
  ];

  makeFlags = [ "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}" ];

  unpackPhase = ''
    runHook preUnpack
    sourceRoot=broadcom-sta
    mkdir "$sourceRoot"
    tar xvf "$src" -C "$sourceRoot"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    docDir="$out/share/doc/broadcom-sta/"
    mkdir -p "$binDir" "$docDir"
    cp wl.ko "$binDir"
    cp lib/LICENSE.txt "$docDir"
    runHook postInstall
  '';

  meta = {
    description = "Kernel module driver for some Broadcom's wireless cards";
    homepage = "http://www.broadcom.com/support/802.11/linux_sta.php";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
