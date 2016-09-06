{ stdenv, fetchurl, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "iperf-3.3";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "1n442bjkm1dvzmcj8z1i99yrmba489yz3f5v27ybymhh4mqn4nbg";
  };

  buildInputs = [ openssl ];

  preConfigure = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -D_GNU_SOURCE"
  '';

  patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "http://git.alpinelinux.org/cgit/aports/plain/main/iperf3/build-fixes.patch";
      name = "fix-musl-build.patch";
      sha256 = "0zvfjnqdldh6rc6qggyb310swdnl9qk0m3z1kklnqzgjsh8dskvl";
    })
    (fetchpatch {
      url = "http://git.alpinelinux.org/cgit/aports/plain/main/iperf3/remove-pg-flags.patch";
      name = "remove-pg-flags.patch";
      sha256 = "0lnczhass24kgq59drgdipnhjnw4l1cy6gqza7f2ah1qr4q104rm";
    })
];

  postInstall = ''
    ln -s iperf3 $out/bin/iperf
  '';

  meta = with stdenv.lib; {
    homepage = http://software.es.net/iperf/; 
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = "as-is";
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
