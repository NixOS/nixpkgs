{
  libpcap,
  libresolv,
  libutil,
  mkAppleDerivation,
  openssl,
  pkg-config,
  sourceRelease,
  stdenvNoCC,
  unifdef,
  xnuHeaders,
}:

let
  xnu = sourceRelease "xnu";

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
        '${xnuHeaders}/include/kern/cs_blobs.h'

      install -D -t "$out/include/firehose" \
        '${xnu}/libkern/firehose/firehose_types_private.h' \
        '${xnu}/libkern/firehose/tracepoint_private.h'

      for dir in arm i386 kern machine; do
        mkdir -p "$out/include/$dir"
        for file in '${xnuHeaders}/include/'$dir/*; do
          name=$(basename "$file")
          # Skip copying `endian.h` because it conflicts with the SDK, breaking the build on x86_64-darwin.
          test "$name" != endian.h && cp -r "$file" "$out/include/$dir/$name"
        done
      done

      unifdef -x 1 -DKERNEL_PRIVATE -o "$out/include/arm/locks.h" '${xnu}/osfmk/arm/locks.h'
      unifdef -x 1 -DKERNEL_PRIVATE -o "$out/include/i386/locks.h" '${xnu}/osfmk/i386/locks.h'

      install -D -t "$out/include/net" \
        '${xnuHeaders}/include/net/bpf.h' \
        '${xnuHeaders}/include/net/bpf_private.h' \
        '${xnuHeaders}/include/net/content_filter.h' \
        '${xnuHeaders}/include/net/droptap.h' \
        '${xnuHeaders}/include/net/if.h' \
        '${xnuHeaders}/include/net/if_bond_internal.h' \
        '${xnuHeaders}/include/net/if_bond_var.h' \
        '${xnuHeaders}/include/net/if_bridgevar.h' \
        '${xnuHeaders}/include/net/if_fake_var.h' \
        '${xnuHeaders}/include/net/if_llreach.h' \
        '${xnuHeaders}/include/net/if_mib.h' \
        '${xnuHeaders}/include/net/if_mib_private.h' \
        '${xnuHeaders}/include/net/if_ports_used.h' \
        '${xnuHeaders}/include/net/if_private.h' \
        '${xnuHeaders}/include/net/if_var_private.h' \
        '${xnuHeaders}/include/net/if_vlan_var.h' \
        '${xnuHeaders}/include/net/lacp.h' \
        '${xnuHeaders}/include/net/net_api_stats.h' \
        '${xnuHeaders}/include/net/net_perf.h' \
        '${xnuHeaders}/include/net/network_agent.h' \
        '${xnuHeaders}/include/net/ntstat.h' \
        '${xnuHeaders}/include/net/packet_mangler.h' \
        '${xnuHeaders}/include/net/pktap.h' \
        '${xnuHeaders}/include/net/radix.h' \
        '${xnuHeaders}/include/net/route.h' \
        '${xnuHeaders}/include/net/route_private.h'

      install -D -t "$out/include/net/classq" \
        '${xnuHeaders}/include/net/classq/classq.h' \
        '${xnuHeaders}/include/net/classq/if_classq.h'

      install -D -t "$out/include/net/pktsched" \
        '${xnuHeaders}/include/net/pktsched/pktsched.h' \
        '${xnuHeaders}/include/net/pktsched/pktsched_fq_codel.h'

      cat <<EOF > "$out/include/net/if_var.h"
      #pragma once
      #include <net/if_var_private.h>
      /* These aren’t defined in the headers in the XNU source */
      #define IF_NETEM_MODEL_IOD 2
      #define IF_NETEM_MODEL_FPD 3
      #include <${xnuHeaders}/include/net/if_var.h>
      EOF

      install -D -t "$out/include/netinet" \
        '${xnuHeaders}/include/netinet/icmp6.h' \
        '${xnuHeaders}/include/netinet/igmp_var.h' \
        '${xnuHeaders}/include/netinet/in.h' \
        '${xnuHeaders}/include/netinet/in_pcb.h' \
        '${xnuHeaders}/include/netinet/in_private.h' \
        '${xnuHeaders}/include/netinet/in_stat.h' \
        '${xnuHeaders}/include/netinet/ip_dummynet.h' \
        '${xnuHeaders}/include/netinet/ip_flowid.h' \
        '${xnuHeaders}/include/netinet/mptcp_var.h' \
        '${xnuHeaders}/include/netinet/tcp.h' \
        '${xnuHeaders}/include/netinet/tcp_private.h' \
        '${xnuHeaders}/include/netinet/tcp_var.h' \
        '${xnuHeaders}/include/netinet/udp_var.h'

      install -D -t "$out/include/netinet6" \
        '${xnuHeaders}/include/netinet6/in6.h' \
        '${xnuHeaders}/include/netinet6/in6_private.h' \
        '${xnuHeaders}/include/netinet6/in6_var.h' \
        '${xnuHeaders}/include/netinet6/in6_pcb.h' \
        '${xnuHeaders}/include/netinet6/ip6_var.h' \
        '${xnuHeaders}/include/netinet6/mld6_var.h'

      mkdir -p "$out/include/netinet6"
      cat <<EOF > "$out/include/netinet6/nd6.h"
      #pragma once
      #include <net/if_dl.h> /* The private nd6.h depends on sockaddr_dl but fails to include if_dl.h. */
      #include <${xnuHeaders}/include/netinet6/nd6.h>
      EOF

      install -D -t "$out/include/os" \
        '${xnuHeaders}/Library/Frameworks/Kernel.framework/PrivateHeaders/os/atomic_private.h' \
        '${xnuHeaders}/Library/Frameworks/Kernel.framework/PrivateHeaders/os/atomic_private_arch.h' \
        '${xnuHeaders}/Library/Frameworks/Kernel.framework/PrivateHeaders/os/atomic_private_impl.h' \
        '${xnu}/libkern/os/log_private.h'

      install -D -t "$out/include/skywalk" \
        '${xnuHeaders}/include/skywalk/os_channel.h' \
        '${xnuHeaders}/include/skywalk/os_channel_event.h' \
        '${xnuHeaders}/include/skywalk/os_nexus.h' \
        '${xnuHeaders}/include/skywalk/os_packet.h'

      install -D -t "$out/include/sys" \
        '${xnuHeaders}/include/sys/kern_control.h' \
        '${xnuHeaders}/include/sys/kern_control_private.h' \
        '${xnuHeaders}/include/sys/kern_event.h' \
        '${xnuHeaders}/include/sys/kern_event_private.h' \
        '${xnuHeaders}/include/sys/mbuf.h' \
        '${xnuHeaders}/include/sys/socket.h' \
        '${xnuHeaders}/include/sys/socket_private.h' \
        '${xnuHeaders}/include/sys/socketvar.h' \
        '${xnuHeaders}/include/sys/sockio.h' \
        '${xnuHeaders}/include/sys/sockio_private.h' \
        '${xnuHeaders}/include/sys/sys_domain.h' \
        '${xnuHeaders}/include/sys/sys_domain_private.h' \
        '${xnuHeaders}/include/sys/syslimits.h' \
        '${xnuHeaders}/include/sys/unpcb.h' \
        '${xnuHeaders}/include/sys/vsock_private.h'
    '';
  };
in
mkAppleDerivation {
  releaseName = "network_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-1RJ/s9vnfCGY2Vc2XH8dg8rB+0lwK2IBC7zIx4PuXWQ=";

  patches = [
    # Some private headers depend on corecrypto, which we can’t use.
    # Use the headers from the ld64 port, which delegates to OpenSSL.
    ./patches/0007-Add-OpenSSL-based-CoreCrypto-digest-functions.patch
  ];

  postPatch = ''
    # Fix invalid pointer conversion error from trying to pass `NULL` to a `size_t`.
    substituteInPlace ndp.tproj/ndp.c --replace-fail 'NULL, NULL);' 'NULL, 0);'
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpcap
    libresolv
    libutil
    openssl
  ];

  meta.description = "Network commands for Darwin";
}
