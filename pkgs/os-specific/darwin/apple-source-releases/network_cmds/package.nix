{
  lib,
  apple-sdk,
  fetchurl,
  libpcap,
  libresolv,
  mkAppleDerivation,
  openssl,
  pkg-config,
  stdenvNoCC,
  unifdef,
}:

let
  # Newer releases of ifconfig use `ioctls` and undocumented APIs newer than 11.x.
  # Use files from an older release for now.
  old_ifconfig = {
    ifconfig = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/ifconfig.tproj/ifconfig.c";
      hash = "sha256-yuUpdRHRwYLnivuaQuh8HJdLj/8ppq+K1NFqA8Bg+1k=";
    };
    af_inet = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/ifconfig.tproj/af_inet.c";
      hash = "sha256-sqcCEzhTur43DG6Ac/1Rt8Kx0umWhDzlV58t+6FlzNU=";
    };
    af_inet6 = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/ifconfig.tproj/af_inet6.c";
      hash = "sha256-jp0R0Ncwvp9G/lIzKW6wBTAiO8yNyII5c49feTanbIo=";
    };
    af_link = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/ifconfig.tproj/af_link.c";
      hash = "sha256-5rXJg5azy9SjK675Djt4K1PaczsoVjQ/Lls/u5Kk1+A=";
    };
  };

  # Newer releases of netstat use struct members that aren’t present with the 11.x headers.
  # Use files from an older release for now.
  old_netstat = {
    "if.c" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/if.c";
      hash = "sha256-P87rexLkoV1BCyUghVrkGoG6r9rAoWynfpvlwIj7A40=";
    };
    "main.c" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/main.c";
      hash = "sha256-e3n54l6Wo+G5koMhGMfOTo8+QIkJRurr2fBOjg/nFgI=";
    };
    "inet.c" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/inet.c";
      hash = "sha256-X1+dz+D6xR2Xqoxypjmy65pKBCh4iGVfByJGI0wVGO0=";
    };
    "inet6.c" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/inet6.c";
      hash = "sha256-av5K1UQE3edUbzKN9FIn/DOeibsJaTZc0xJzDu9VZ5Q=";
    };
    "netstat.h" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/netstat.h";
      hash = "sha256-UYi3lmA8G0wRJqVA2NYyMj0yCBUlxu0gMoMYW7NauJg=";
    };
    "unix.c" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/unix.c";
      hash = "sha256-txs/mnR4WK8JAUN3PtqZsp6q2h+nx5VFKxI/itCTBNo=";
    };
    "systm.c" = fetchurl {
      url = "https://github.com/apple-oss-distributions/network_cmds/raw/2e18102a14ab72b25caf3a5007c92b9f23e723fc/netstat.tproj/systm.c";
      hash = "sha256-bISSIsA6OYfkHNOKB4dj9KNLBHfcelGVzwGiYiVqnRM=";
    };
  };

  xnu = apple-sdk.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "network_cmds-deps-private-headers";

    nativeBuildInputs = [ unifdef ];

    buildCommand = ''
      # Different strategies are needed to make private headers available to network_cmds:
      # - If the headers can be used as-is, copy them;
      # - If the required symbols are hidden behind a 'PRIVATE' define, `unifdef` is used to expose only those symbols
      #   for that header. Processing the header avoids exposing unwanted private symbols and requiring more headers;
      # - If the symbol is hidden behind a kernel-related define, grep them out of the header. Otherwise,
      #   the required headers can conflict with system-related headers and require many, many more headers be copied.

      install -D -t "$out/include" \
        '${xnu}/osfmk/kern/cs_blobs.h'

      install -D -t "$out/firehose" \
        '${xnu}/libkern/firehose/tracepoint_private.h'

      install -D -t "$out/include/net" \
        '${xnu}/bsd/net/if_bond_internal.h' \
        '${xnu}/bsd/net/if_bond_var.h' \
        '${xnu}/bsd/net/if_fake_var.h' \
        '${xnu}/bsd/net/if_vlan_var.h' \
        '${xnu}/bsd/net/lacp.h' \
        '${xnu}/bsd/net/net_perf.h'
      mkdir -p "$out/include/net/classq" "$out/include/net/pktsched"

      # IFNET constants are defined as enums, so they have to be pre-processed and grepped from the file.
      cat <<EOF > "$out/include/net/if.h"
      #pragma once
      #include <uuid/uuid.h>
      $(sed \
        -e 's/^\s*\(IFNET_[^=]*\)=\s*\([^,]*\),*/#define \1\2/' \
        '${xnu}/bsd/net/if.h' | grep '^#define IFNET_')
      #include_next <net/if.h>
      #include <netinet/in.h>
      #define ifreq ifreq_private
      $(sed -n \
        -e '/^#define IFEF_TXSTART/p' \
        -e '/^#define IFLPRF/p' \
        -e '/^#define IFNAMSIZ\s/p' \
        -e '/^#define IFRLOGF/p' \
        -e '/^#define IFRTYPE/p' \
        -e '/^#define IF_DESCSIZE\s/p' \
        -e '/^#define IF_NAMESIZE\s/p' \
        -e '/^#define NAT64_MAX_NUM_PREFIXES\s/p' \
        -e '/^#define ifr_fastlane_capable\s/p' \
        -e '/^#define ifr_fastlane_enabled\s/p' \
        -e '/^#define ifr_qosmarking_enabled\s/p' \
        -e '/^#define ifr_qosmarking_mode\s/p' \
        -e '/^struct if_agentidsreq\s*{/,/^};/p' \
        -e '/^struct if_clat46req\s*{/,/^};/p' \
        -e '/^struct if_descreq\s*{/,/^};/p' \
        -e '/^struct if_ipv6_address\s*{/,/^};/p' \
        -e '/^struct if_linkparamsreq\s*{/,/^};/p' \
        -e '/^struct if_qstatsreq\s*{/,/^};/p' \
        -e '/^struct if_nat64req\s*{/,/^};/p' \
        -e '/^struct if_nexusreq\s*{/,/^};/p' \
        -e '/^struct if_throttlereq\s*{/,/^};/p' \
        -e '/^struct ipv6_prefix\s*{/,/^};/p' \
        -e '/^struct  ifreq\s*{/,/^};/p' \
        '${xnu}/bsd/net/if.h')
      #undef ifreq
      EOF
      unifdef -x 1 -DPRIVATE -m "$out/include/net/if.h"

      cat <<EOF > "$out/include/net/content_filter.h"
      #pragma once
      #include <uuid/uuid.h>
      #include <net/content_filter_impl.h>
      EOF

      cat <<EOF > "$out/include/net/if_var.h"
      #pragma once
      #include_next <net/if_var.h>
      $(sed -n \
        -e '/^#define IFNAMSIZ\s/p' \
        -e '/^#define IF_NETEM/p' \
        -e '/^struct if_bandwidths\s*{/,/^};/p' \
        -e '/^struct if_data_extended\s*{/,/^};/p' \
        -e '/^struct if_interface_state\s*{/,/^};/p' \
        -e '/^struct if_latencies\s*{/,/^};/p' \
        -e '/^struct if_linkparamsreq\s*{/,/^};/p' \
        -e '/^struct if_netem_params\s*{/,/^};/p' \
        -e '/^struct if_netif_stats\s*{/,/^};/p' \
        -e '/^struct if_packet_stats\s*{/,/^};/p' \
        -e '/^struct if_rxpoll_stats\s*{/,/^};/p' \
        -e '/^struct if_traffic_class\s*{/,/^};/p' \
        '${xnu}/bsd/net/if_var.h')
      EOF

      cat <<EOF > "$out/include/net/route.h"
      #pragma once
      #include_next <net/route.h>
      $(sed -n \
        -e '/^struct rt_msghdr_ext\s*{/,/^};/p' \
        -e '/^struct rt_reach_info\s*{/,/^};/p' \
        '${xnu}/bsd/net/route.h')
      EOF
      ln -s "$out/include/net/route.h" "$out/include/net/route_private.h"

      install -D -t "$out/include/netinet" \
        '${xnu}/bsd/netinet/ip_flowid.h'

      cat <<EOF > "$out/include/netinet/in.h"
      #pragma once
      #include_next <netinet/in.h>
      $(sed -n \
        -e '/^#define _DSCP/p' \
        -e '/^#define IP_NO/p' \
        -e '/^union sockaddr_in_4_6\s*{/,/^};/p' \
        '${xnu}/bsd/netinet/in.h')
      #include <uuid/uuid.h>
      EOF

      cat <<EOF > "$out/include/netinet/tcp.h"
      #pragma once
      $(sed -n \
        -e '/^struct tcp_info\s*{/,/^};/p' \
        -e '/^struct tcp_conn_status\s*{/,/^};/p' \
        -e '/^typedef struct conninfo_tcp\s*{/,/} conninfo_tcp_t;/p' \
        '${xnu}/bsd/netinet/tcp.h')
      #include_next <netinet/tcp.h>
      EOF

      install -D -t "$out/include/netinet6" \
        '${xnu}/bsd/netinet6/in6_pcb.h' \
        '${xnu}/bsd/netinet6/ip6_var.h'

      cat <<EOF > "$out/include/netinet6/in6.h"
      #pragma once
      $(sed -n \
        -e '/^#define IPV6_/p' \
        '${xnu}/bsd/netinet6/in6.h')
      #include_next <netinet6/in6.h>
      EOF

      cat <<EOF > "$out/include/netinet6/in6_var.h"
      #pragma once
      $(sed -n \
        -e '/^#define IN6_CGA/p' \
        -e '/^#define SIOCSETROUTERMODE_IN6\s/p' \
        -e '/^struct in6_cga_modifier\s*{/,/^};/p' \
        -e '/^struct in6_cga_nodecfg\s*{/,/^};/p' \
        -e '/^struct in6_cga_prepare\s*{/,/^};/p' \
        '${xnu}/bsd/netinet6/in6_var.h')
      #include_next <netinet6/in6_var.h>
      EOF

      mkdir -p "$out/include/netinet6"
      cat <<EOF > "$out/include/netinet6/nd6.h"
      #pragma once
      $(sed -n \
        -e '/^#define ND6_IFF/p' \
        '${xnu}/bsd/netinet6/nd6.h')
      #include_next <netinet6/nd6.h>
      EOF

      install -D -t "$out/include/os" \
        '${xnu}/libkern/os/log_private.h'

      declare -a privateHeaders=(
        net/classq/classq.h
        net/classq/if_classq.h
        net/if_bridgevar.h
        net/if_llreach.h
        net/if_mib.h
        net/if_ports_used.h
        net/net_api_stats.h
        net/network_agent.h
        net/ntstat.h
        net/packet_mangler.h
        net/pktap.h
        net/pktsched/pktsched.h
        net/pktsched/pktsched_fq_codel.h
        net/radix.h
        netinet/igmp_var.h
        netinet/in_pcb.h
        netinet/in_stat.h
        netinet/ip_dummynet.h
        netinet/mptcp_var.h
        netinet/tcp_var.h
        netinet6/mld6_var.h
        sys/mbuf.h
      )

      mkdir -p "$out/include/sys"

      for header in "''${privateHeaders[@]}"; do
        unifdef -x 1 -DPRIVATE -o "$out/include/$header" '${xnu}/bsd/'$header
      done
      unifdef -x 1 -DPRIVATE -o "$out/include/net/content_filter_impl.h" '${xnu}/bsd/net/content_filter.h'

      cat <<EOF > "$out/include/sys/kern_control.h"
      #pragma once
      $(sed -n \
        -e '/^#define MAX_KCTL_NAME\s/p' \
        -e '/^struct kctlstat\s*{/,/^};/p' \
        -e '/^struct xkctl_reg\s*{/,/^};/p' \
        -e '/^struct xkctlpcb\s*{/,/^};/p' \
        '${xnu}/bsd/sys/kern_control.h')
      #include_next <sys/kern_control.h>
      EOF

      cat <<EOF > "$out/include/sys/kern_event.h"
      #pragma once
      $(sed -n \
        -e '/^struct kevtstat\s*{/,/^};/p' \
        -e '/^struct xkevtpcb\s*{/,/^};/p' \
        '${xnu}/bsd/sys/kern_event.h')
      #include_next <sys/kern_event.h>
      EOF

      cat <<EOF > "$out/include/sys/socket.h"
      #pragma once
      #include <sys/param.h>
      #include <sys/_types/_socklen_t.h>
      $(sed -n \
        -e '/^#define AF_MULTIPATH\s/p' \
        -e '/^#define CIAUX_TCP\s/p' \
        -e '/^#define NET_RT_/p' \
        -e '/^#define SO_RECV/p' \
        -e '/^#define SO_TRAFFIC_CLASS\s/,/^#define SO_TC_MAX/p' \
        -e '/^typedef.*sae_associd_t/p' \
        -e '/^typedef.*sae_connid_t/p' \
        -e '/^struct so_aidreq\s*{/,/^};/p' \
        -e '/^struct so_cidreq\s*{/,/^};/p' \
        -e '/^struct so_cinforeq\s*{/,/^};/p' \
        -e '/^struct so_cordreq\s*{/,/^};/p' \
        '${xnu}/bsd/sys/socket.h')
      #include_next <sys/socket.h>
      EOF

      cat <<EOF > "$out/include/sys/socketvar.h"
      #pragma once
      $(sed -n \
        -e '/^#define SO_TC_STATS_MAX\s/p' \
        -e '/^#define XSO_/p' \
        -e '/^struct data_stats\s*{/,/^};/p' \
        -e '/^struct soextbkidlestat\s*{/,/^};/p' \
        -e '/^struct  xsocket_n\s*{/,/^};/p' \
        -e '/^struct xsockbuf_n\s*{/,/^};/p' \
        -e '/^struct xsockstat_n\s*{/,/^};/p' \
        '${xnu}/bsd/sys/socketvar.h')
      #include_next <sys/socketvar.h>
      EOF

      cat <<EOF > "$out/include/sys/sockio.h"
      #pragma once
      #define ifreq ifreq_private
      $(sed -n \
        -e '/^#define SIOCGASSOCIDS\s/p' \
        -e '/^#define SIOCGCONNIDS\s/p' \
        -e '/^#define SIOCGCONNINFO\s/p' \
        -e '/^#define SIOCGIFAGENTDATA\s/p' \
        -e '/^#define SIOCGIFAGENTIDS\s/p' \
        -e '/^#define SIOCGIFCLAT46ADDR\s/p' \
        -e '/^#define SIOCGIFDELEGATE\s/p' \
        -e '/^#define SIOCGIFDESC\s/p' \
        -e '/^#define SIOCGIFEFLAGS\s/p' \
        -e '/^#define SIOCGIFGETRTREFCNT\s/p' \
        -e '/^#define SIOCGIFINTERFACESTATE\s/p' \
        -e '/^#define SIOCGIFLINKPARAMS\s/p' \
        -e '/^#define SIOCGIFLINKQUALITYMETRIC\s/p' \
        -e '/^#define SIOCGIFLOG\s/p' \
        -e '/^#define SIOCGIFLOWPOWER\s/p' \
        -e '/^#define SIOCGIFMPKLOG\s/p' \
        -e '/^#define SIOCGIFNAT64PREFIX\s/p' \
        -e '/^#define SIOCGIFNEXUS\s/p' \
        -e '/^#define SIOCGIFQUEUESTATS\s/p' \
        -e '/^#define SIOCGIFTHROTTLE\s/p' \
        -e '/^#define SIOCGIFTIMESTAMPENABLED\s/p' \
        -e '/^#define SIOCGIFTYPE\s/p' \
        -e '/^#define SIOCGIFXFLAGS\s/p' \
        -e '/^#define SIOCGSTARTDELAY\s/p' \
        -e '/^#define SIOCSECNMODE\s/p' \
        -e '/^#define SIOCSETROUTERMODE\s/p' \
        -e '/^#define SIOCSFASTLANECAPABLE\s/p' \
        -e '/^#define SIOCSFASTLEENABLED\s/p' \
        -e '/^#define SIOCSIF2KCL\s/p' \
        -e '/^#define SIOCSIFDESC\s/p' \
        -e '/^#define SIOCSIFDISABLEOUTPUT\s/p' \
        -e '/^#define SIOCSIFEXPENSIVE\s/p' \
        -e '/^#define SIOCSIFINTERFACESTATE\s/p' \
        -e '/^#define SIOCSIFLINKPARAMS\s/p' \
        -e '/^#define SIOCSIFLOG\s/p' \
        -e '/^#define SIOCSIFLOWPOWER\s/p' \
        -e '/^#define SIOCSIFMPKLOG\s/p' \
        -e '/^#define SIOCSIFPROBECONNECTIVITY\s/p' \
        -e '/^#define SIOCSIFSUBFAMILY\s/p' \
        -e '/^#define SIOCSIFTHROTTLE\s/p' \
        -e '/^#define SIOCSIFTIMESTAMPDISABLE\s/p' \
        -e '/^#define SIOCSIFTIMESTAMPENABLE\s/p' \
        -e '/^#define SIOCSQOSMARKINGENABLED\s/p' \
        -e '/^#define SIOCSQOSMARKINGMODE\s/p' \
        '${xnu}/bsd/sys/sockio.h')
      #undef ifreq
      #include_next <sys/sockio.h>
      EOF

      cat <<EOF > "$out/include/sys/sys_domain.h"
      #pragma once
      $(sed -n \
        -e '/^#define AF_SYS/p' \
        -e '/^#define SYSPROTO/p' \
        -e '/^struct  xsystmgen\s*{/,/^};/p' \
        '${xnu}/bsd/sys/sys_domain.h')
      #include_next <sys/sys_domain.h>
      EOF

      cat <<EOF > "$out/include/sys/syslimits.h"
      #pragma once
      $(grep '^#define LINE_MAX\s' '${xnu}/bsd/sys/syslimits.h')
      #include_next <sys/syslimits.h>
      EOF

      cat <<EOF > "$out/include/sys/unpcb.h"
      #pragma once
      #include_next <sys/unpcb.h>
      $(sed -n \
        -e '/^#define xu_addr/p' \
        -e '/^struct xunpcb64_list_entry\s*{/,/^};/p' \
        -e '/^struct xunpcb64\s*{/,/^};/p' \
        '${xnu}/bsd/sys/unpcb.h')
    '';
  };
in
mkAppleDerivation {
  releaseName = "network_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-HkcIvKB4ektuk+3J/Sque8Pr5dMeNFZRlENuiu3KdsA=";

  patches = [
    # Some private headers depend on corecrypto, which we can’t use.
    # Use the headers from the ld64 port, which delegates to OpenSSL.
    ./patches/0007-Add-OpenSSL-based-CoreCrypto-digest-functions.patch
  ];

  postPatch = ''
    # Fix invalid pointer conversion error from trying to pass `NULL` to a `size_t`.
    substituteInPlace ndp.tproj/ndp.c --replace-fail 'NULL, NULL);' 'NULL, 0);'

    # Copy older files that are more compatible with the current SDK.
    ${lib.concatLines (
      lib.mapAttrsToList (name: path: "cp '${path}' 'ifconfig.tproj/${name}.c'") old_ifconfig
    )}

    ${lib.concatLines (
      lib.mapAttrsToList (name: path: "cp '${path}' 'netstat.tproj/${name}'") old_netstat
    )}

    # Use private struct ifreq instead of the one defined in the system header.
    substituteInPlace ifconfig.tproj/ifconfig.c \
      --replace-fail $'struct\tifreq' 'struct ifreq' \
      --replace-fail 'struct ifreq' 'struct ifreq_private'

    substituteInPlace ifconfig.tproj/ifvlan.c \
      --replace-fail 'struct ifreq' 'struct ifreq_private'

    substituteInPlace ifconfig.tproj/ifconfig.h \
      --replace-fail 'struct ifreq' 'struct ifreq_private'

    substituteInPlace netstat.tproj/if.c \
      --replace-fail 'struct ifreq' 'struct ifreq_private'
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpcap
    libresolv
    openssl
  ];

  meta.description = "Network commands for Darwin";
}
