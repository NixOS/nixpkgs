{ stdenv, stdenvNoCC, lib, fetchzip, pkgs
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
}:
let

  choosePlatform =
    let pname = stdenv.targetPlatform.parsed.cpu.name; in
    pset: pset.${pname} or (throw "bionic-prebuilt: unsupported platform ${pname}");

  prebuilt_crt = choosePlatform {
    aarch64 = fetchzip {
      url =  "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/98dce673ad97a9640c5d90bbb1c718e75c21e071/lib/gcc/aarch64-linux-android/4.9.x.tar.gz";
      sha256 = "sha256-LLD2OJi78sNN5NulOsJZl7Ei4F1EUYItGG6eUsKWULc=";
      stripRoot = false;
    };
    x86_64 = fetchzip {
      url = "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/+archive/7e8507d2a2d4df3bced561b894576de70f065be4/lib/gcc/x86_64-linux-android/4.9.x.tar.gz";
      sha256 = "sha256-y7CFLF76pTlj+oYev9taBnL2nlT3+Tx8c6wmicWmKEw=";
      stripRoot = false;
    };
  };

  prebuilt_libs = choosePlatform {
    aarch64 = fetchzip {
      url = "https://android.googlesource.com/platform/prebuilts/ndk/+archive/f2c77d8ba8a7f5c2d91771e31164f29be0b8ff98/platform/platforms/android-30/arch-arm64/usr/lib.tar.gz";
      sha256 = "sha256-TZBV7+D1QvKOCEi+VNGT5SStkgj0xRbyWoLH65zSrjw=";
      stripRoot = false;
    };
    x86_64 = fetchzip {
      url = "https://android.googlesource.com/platform/prebuilts/ndk/+archive/f2c77d8ba8a7f5c2d91771e31164f29be0b8ff98/platform/platforms/android-30/arch-x86_64/usr/lib64.tar.gz";
      sha256 = "sha256-n2EuOKy3RGKmEYofNlm+vDDBuiQRuAJEJT6wq6NEJQs=";
      stripRoot = false;
    };
  };

  prebuilt_ndk_crt = choosePlatform {
    aarch64 = fetchzip {
      url = "https://android.googlesource.com/toolchain/prebuilts/ndk/r23/+archive/6c5fa4c0d3999b9ee932f6acbd430eb2f31f3151/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/aarch64-linux-android/30.tar.gz";
      sha256 = "sha256-KHw+cCwAwlm+5Nwp1o8WONqdi4BBDhFaVVr+7GxQ5uE=";
      stripRoot = false;
    };
    x86_64 = fetchzip {
      url = "https://android.googlesource.com/toolchain/prebuilts/ndk/r23/+archive/6c5fa4c0d3999b9ee932f6acbd430eb2f31f3151/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/x86_64-linux-android/30.tar.gz";
      sha256 = "sha256-XEd7L3cBzn+1pKfji40V92G/uZhHSMMuZcRZaiKkLnk=";
      stripRoot = false;
    };
  };

  ndk_support_headers = fetchzip {
    url ="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/0e7f808fa26cce046f444c9616d9167dafbfb272/clang-r416183b/include/c++/v1/support.tar.gz";
    sha256 = "sha256-NBv7Pk1CEaz8ns9moleEERr3x/rFmVmG33LgFSeO6fY=";
    stripRoot = false;
  };

  kernelHeaders = pkgs.makeLinuxHeaders {
    version = "android-common-11-5.4";
    src = fetchzip {
      url = "https://android.googlesource.com/kernel/common/+archive/48ffcbf0b9e7f0280bfb8c32c68da0aaf0fdfef6.tar.gz";
      sha256 = "1y7cmlmcr5vdqydd9n785s139yc4aylc3zhqa59xsylmkaf5habk";
      stripRoot = false;
    };
  };

in
stdenvNoCC.mkDerivation rec {
  pname = "bionic-prebuilt";
  version = "ndk-release-r23";
  name = "${stdenv.targetPlatform.parsed.cpu.name}-${pname}-${version}";

  src = fetchzip {
    url = "https://android.googlesource.com/platform/bionic/+archive/00e8ce1142d8823b0d2fc8a98b40119b0f1f02cd.tar.gz";
    sha256 = "10z5mp4w0acvjvgxv7wlqa7m70hcyarmjdlfxbd9rwzf4mrsr8d1";
    stripRoot = false;
  };

  NIX_DONT_SET_RPATH = true;

  dontConfigure = true;
  dontBuild = true;

  patches = [
    ./ndk-version.patch
  ];

  postPatch = ''
    substituteInPlace libc/include/sys/cdefs.h --replace \
      "__has_builtin(__builtin_umul_overflow)" "1"
    substituteInPlace libc/include/bits/ioctl.h --replace \
      "!defined(BIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD)" "0"
  '';

  installPhase= ''
    # copy the bionic headers
    mkdir -p $out/include/support $out/include/android
    cp -vr libc/include/* $out/include
    # copy the kernel headers
    cp -vr ${kernelHeaders}/include/*  $out/include/

    chmod -R +w $out/include/linux

    # fix a bunch of kernel headers so that things can actually be found
    sed -i 's,struct epoll_event {,#include <bits/epoll_event.h>\nstruct Xepoll_event {,' $out/include/linux/eventpoll.h
    sed -i 's,struct in_addr {,typedef unsigned int in_addr_t;\nstruct in_addr {,' $out/include/linux/in.h
    sed -i 's,struct udphdr {,struct Xudphdr {,' $out/include/linux/udp.h
    sed -i 's,union semun {,union Xsemun {,' $out/include/linux/sem.h
    sed -i 's,struct __kernel_sockaddr_storage,#define sockaddr_storage __kernel_sockaddr_storage\nstruct __kernel_sockaddr_storage,' $out/include/linux/socket.h
    sed -i 's,#ifndef __UAPI_DEF_.*$,#if 1,' $out/include/linux/libc-compat.h
    substituteInPlace $out/include/linux/in.h --replace "__be32		imr_" "struct in_addr		imr_"
    substituteInPlace $out/include/linux/in.h --replace "__be32		imsf_" "struct in_addr		imsf_"
    substituteInPlace $out/include/linux/sysctl.h --replace "__unused" "_unused"

    # what could possibly live in <linux/compiler.h>
    touch $out/include/linux/compiler.h

    # copy the support headers
    cp -vr ${ndk_support_headers}* $out/include/support/

    mkdir $out/lib
    cp -v ${prebuilt_crt.out}/*.o $out/lib/
    cp -v ${prebuilt_crt.out}/libgcc.a $out/lib/
    cp -v ${prebuilt_ndk_crt.out}/*.o $out/lib/
  '' + lib.optionalString enableShared ''
    for i in libc.so libm.so libdl.so liblog.so; do
      cp -v ${prebuilt_libs.out}/$i $out/lib/
    done
  '' + lib.optionalString enableStatic ''
    # no liblog.a; while it's also part of the base libraries,
    # it's only available as shared object in the prebuilts.
    for i in libc.a libm.a libdl.a; do
      cp -v ${prebuilt_ndk_crt.out}/$i $out/lib/
    done
  '' + ''
    mkdir -p $dev/include
    cp -v $out/include/*.h $dev/include/
  '';

  outputs = [ "out" "dev" ];
  passthru.linuxHeaders = kernelHeaders;

  meta = with lib; {
    description = "The Android libc implementation";
    homepage    = "https://android.googlesource.com/platform/bionic/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ s1341 ];
  };
}
