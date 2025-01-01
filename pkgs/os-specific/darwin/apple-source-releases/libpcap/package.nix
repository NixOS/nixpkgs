{
  lib,
  apple-sdk_15,
  bison,
  bluez,
  flex,
  mkAppleDerivation,
  stdenv,
  stdenvNoCC,
  unifdef,
  # Provided for compatibility with the top-level derivation.
  withBluez ? false,
  withRemote ? false,
}:

let
  xnu = apple-sdk_15.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "libpcap-deps-private-headers";

    nativeBuildInputs = [ unifdef ];

    buildCommand = ''
      mkdir -p "$out/include/net"
      unifdef -x 1 -DPRIVATE -o "$out/include/net/droptap.h" '${xnu}/bsd/net/droptap.h'
      unifdef -x 1 -DPRIVATE -o "$out/include/net/iptap.h" '${xnu}/bsd/net/iptap.h'
      unifdef -x 1 -DPRIVATE -o "$out/include/net/pktap.h" '${xnu}/bsd/net/pktap.h'

      cat <<EOF > "$out/include/net/bpf.h"
      #pragma once
      #include_next <net/bpf.h>
      $(sed -n \
        -e '/^struct bpf_comp_stats\s*{/,/};/p' \
        -e '/^struct bpf_hdr_ext\s*{/,/};/p' \
        -e '/^#define BIOCGBATCHWRITE\s/p' \
        -e '/^#define BIOCGHDRCOMPSTATS\s/p' \
        -e '/^#define BIOCGIFATTACHCOUNT\s/p' \
        -e '/^#define BIOCGWRITEMAX\s/p' \
        -e '/^#define BIOCSBATCHWRITE\s/p' \
        -e '/^#define BIOCSEXTHDR\s/p' \
        -e '/^#define BIOCSHEADDROP\s/p' \
        -e '/^#define BIOCSPKTHDRV2\s/p' \
        -e '/^#define BIOCSTRUNCATE\s/p' \
        -e '/^#define BIOCSWANTPKTAP\s/p' \
        -e '/^#define BIOCSWRITEMAX\s/p' \
        '${xnu}/bsd/net/bpf.h')
      EOF

      cat <<EOF > "$out/include/net/if.h"
      #pragma once
      #include_next <net/if.h>
      #include <net/if_private.h>
      EOF

      cat <<EOF > "$out/include/net/if_private.h"
      #pragma once
      $(sed -n \
        -e '/^#define IF_DESCSIZE\s/p' \
        -e '/^struct if_descreq\s*{/,/};/p' \
        '${xnu}/bsd/net/if_private.h')
      EOF

      mkdir -p "$out/include/sys"

      cat <<EOF > "$out/include/sys/socket.h"
      #pragma once
      #include <sys/param.h>
      #include <sys/_types/_socklen_t.h>
      $(sed -n \
        -e '/^#define SO_TC/p' \
        '${xnu}/bsd/sys/socket_private.h')
      #include_next <sys/socket.h>
      EOF

      cat <<EOF > "$out/include/sys/sockio.h"
      #pragma once
      $(sed -n \
        -e '/^#define SIOCGIFDESC\s/p' \
        -e '/^#define SIOCSIFDESC\s/p' \
        '${xnu}/bsd/sys/sockio_private.h')
      #include_next <sys/sockio.h>
      EOF
    '';
  };
in
mkAppleDerivation {
  releaseName = "libpcap";

  postPatch = ''
    substituteInPlace libpcap/Makefile.in \
      --replace-fail '@PLATFORM_C_SRC@' '@PLATFORM_C_SRC@ pcap-darwin.c pcap-util.c pcapng.c'
    substituteInPlace libpcap/pcap/pcap.h \
      --replace-fail '#if PRIVATE' '#if 1'
  '';

  configureFlags = [
    (lib.withFeatureAs true "pcap" (if stdenv.hostPlatform.isLinux then "linux" else "bpf"))
    (lib.enableFeature withRemote "remote")
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ (lib.enableFeature false "universal") ];

  preConfigure = ''
    cd libpcap
  '';

  env.NIX_CFLAGS_COMPILE = "-DHAVE_PKTAP_API -I${privateHeaders}/include";

  nativeBuildInputs = [
    bison
    flex
  ] ++ lib.optionals withBluez [ bluez.dev ];

  meta = {
    description = "Packet Capture Library (with Apple modifications)";
    mainProgram = "pcap-config";
  };
}
