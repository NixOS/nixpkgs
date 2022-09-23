{ lib, stdenv, fetchFromGitiles, pkg-config, libuuid, openssl, libyaml, xz }:

stdenv.mkDerivation rec {
  version = "20180311";
  checkout = "4c84e077858c809ee80a9a6f9b38185cf7dcded7";

  pname = "vboot_reference";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    rev = checkout;
    sha256 = "1zja4ma6flch08h5j2l1hqnxmw2xwylidnddxxd5y2x05dai9ddj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libuuid libyaml xz ];

  enableParallelBuilding = true;

  patches = [ ./dont_static_link.patch ];

  NIX_CFLAGS_COMPILE = [
    # fix build with gcc9
    "-Wno-error"
    # workaround build failure on -fno-common toolchains:
    #   ld: /build/source/build/futility/vb2_helper.o:(.bss+0x0): multiple definition of
    #     `vboot_version'; /build/source/build/futility/futility.o:(.bss+0x0): first defined here
    # TODO: remove it when next release contains:
    #   https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/df4d2000a22db673a788b8e57e8e7c0cc3cee777
    "-fcommon"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "ar qc" '${stdenv.cc.bintools.targetPrefix}ar qc'
  '';

  preBuild = ''
    patchShebangs scripts
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "HOST_ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
  ];

  postInstall = ''
    mkdir -p $out/share/vboot
    cp -r tests/devkeys* $out/share/vboot/
  '';

  meta = with lib; {
    description = "Chrome OS partitioning and kernel signing tools";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lheckemann ];
  };
}
