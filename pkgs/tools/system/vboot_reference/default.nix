{ stdenv, fetchgit, pkgconfig, libuuid, openssl, libyaml, lzma }:

stdenv.mkDerivation rec {
  version = "20171023";
  checkout = "8122e0b8b13794";

  name = "vboot_reference-${version}";

  src = fetchgit {
    url = https://chromium.googlesource.com/chromiumos/platform/vboot_reference;
    rev = "${checkout}";
    sha256 = "0qxm3qlvm2fgjrn9b3n8rdccw2f5pdi7z542m2hdfddflx7jz1w7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libuuid libyaml lzma ];

  enableParallelBuilding = true;

  patches = [ ./dont_static_link.patch ];

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

  meta = with stdenv.lib; {
    description = "Chrome OS partitioning and kernel signing tools";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lheckemann ];
  };
}
