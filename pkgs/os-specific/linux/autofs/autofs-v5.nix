args: with args;
let
  baseURL = mirror://kernel/linux/daemons/autofs/v5;

  p = a : b : fetchurl { url = a; sha256 = b; };
  # all patches, let's hopet his finally works
  patches = []; /* [
     (p "${baseURL}/autofs-5.0.4-fix-dumb-libxml2-check.patch" "16fdxxkbcr5yli20vs2al9b3kbdg5bwky7vv8ilf4p2xs341zijd")
     (p "${baseURL}/autofs-5.0.4-expire-specific-submount-only.patch" "0mx1n2mgkld5s9ql83dh71yplx0bjz4xm0sa298k3iganyz1nx83")
     (p "${baseURL}/autofs-5.0.4-fix-negative-cache-non-existent-key.patch" "0k4zmviqhl28zd9fkr7bm8jp99ip43x8g59rhd1bf8n4k64476ks")
     (p "${baseURL}/autofs-5.0.4-fix-ldap-detection.patch" "1yscwl3h6z7ij9wjdbildir8nvz1m6wl8m8n1pjyycq01b2qysh4")
     (p "${baseURL}/autofs-5.0.4-use-CLOEXEC-flag.patch" "0d18g2llwihxr9l6z6lcxl7m7bzmhvqbsx84ypdg78sjysb9q042")
     (p "${baseURL}/autofs-5.0.4-fix-select-fd-limit.patch" "0ppcbj25xmwfb2jk6fgw9ldmzsnnl5a8hsxh60nly62c3mdzsy16")
     (p "${baseURL}/autofs-5.0.4-make-hash-table-scale-to-thousands-of-entries.patch" "1lws4gdwz5qims74g1adivdzrcb0syc7w3y745c324l8jbsqi8i4")
     (p "${baseURL}/autofs-5.0.4-fix-quoted-mess.patch" "158f38jwfkddw73cm0wa01l80v0dskp2wgjwm9kphgpwsvncdzp8")
     (p "${baseURL}/autofs-5.0.4-use-CLOEXEC-flag-setmntent.patch" "0vw4w3pzpwkjjk47vy9mlzpcgm0b9kv24dbp7kl96nnr9fjvmzdm")
     (p "${baseURL}/autofs-5.0.4-fix-hosts-map-use-after-free.patch" "0rgf2q8ci8s969937230sa828d3m0r0kxkna788dw6nkyr322x41")
     (p "${baseURL}/autofs-5.0.4-uris-list-locking-fix.patch" "0hzhgcbrlkjqm8rs32bbn274w7gmfm80r26dggiizz18ji9cdl6k")
     (p "${baseURL}/autofs-5.0.4-renew-sasl-creds-upon-reconnect-fail.patch" "1c2grifkahkdrsg2cw1jxwhfi17qby8582iyb6n7aj4dhc15mjkc")
     (p "${baseURL}/autofs-5.0.4-library-reload-fix-update.patch" "0r3z58jmknl1rqbbnvls5rnnav09phdmx2q1wja0dd5ahnmqn6f5")
     (p "${baseURL}/autofs-5.0.4-force-unlink-umount.patch" "1lx2nf3amdd0dk3rd951ay3739rfbwklapshfyaqa2gxinc3limv")
     (p "${baseURL}/autofs-5.0.4-always-read-file-maps.patch" "0dzmdffdh3sfyq651b0706bjdp21vfvjjs0rr4f0dbfqwyfghbhf")
     (p "${baseURL}/autofs-5.0.4-code-analysis-corrections.patch" "0app6jidxkn0snk6ag6acsy6807vbm4gjlq1ni2kv9a6i91lpcmk")
     (p "${baseURL}/autofs-5.0.4-make-MAX_ERR_BUF-and-PARSE_MAX_BUF-use-easier-to-audit.patch" "0y3rbaqrddkk2zd1vch67frxgv4nqz2b1azbi8cf0aygwsjald0f")
     (p "${baseURL}/autofs-5.0.4-easy-alloca-replacements.patch" "061nmz1l85wdy3ica7sbgl7vshclkr6m72sniaa4yl86ig581xf2")
     (p "${baseURL}/autofs-5.0.4-configure-libtirpc.patch" "14xj2lm8vclmy3awx7jqcjrjws49imf2l79jp1380flgnl47qlaq")
     (p "${baseURL}/autofs-5.0.4-ipv6-name-and-address-support.patch" "0bvy840wxrmcw334jm6jbzml42vs160xphk5c08v3bsnkbr8bppn")
     (p "${baseURL}/autofs-5.0.4-ipv6-parse.patch" "1rqwhbs0jsvrigr8vyzk5bhjf2rpnlsayb4bj3in1c7w9cl65xcl")
     (p "${baseURL}/autofs-5.0.4-add-missing-changelog-entries.patch" "0vwv3rfl4wcda14q3xysv0859bmy8xn56c1g0n94v39733kjbkkv")
     (p "${baseURL}/autofs-5.0.4-use-CLOEXEC-flag-setmntent-include-fix.patch" "1180948d6b3s0kfn6j8m1xs9syb9dh5g12lwq9ljpvz70lsny58f")
     (p "${baseURL}/autofs-5.0.4-easy-alloca-replacements-fix.patch" "0cvfg3i0g668bhh3fiih73m3kzpaqns00l9120mbyx5q2k2w0492")
     (p "${baseURL}/autofs-5.0.4-libxml2-workaround-fix.patch" "08fh7x7x1rwp3nr1h2fpsxf5kj94jpw913ifyv0s71pksrl1i6w7")
     (p "${baseURL}/autofs-5.0.4-configure-libtirpc-fix.patch" "1lnf55k6f3g94kgqr8p5a6ivl9dyafyf8wb8bz25jwdky1mzaw5f")
     (p "${baseURL}/autofs-5.0.4-add-nfs-mount-proto-default-conf-option.patch" "095vzvh2cwnmzsj4kci21lz5zaqhkkkmgfs86m02vivf1dpzay4y")
     (p "${baseURL}/autofs-5.0.4-fix-bad-token-declare.patch" "1f72lz60a3ldn4nvjkby7xv3vg0hsczn7ghx726c5rhwb21iirrf")
     (p "${baseURL}/autofs-5.0.4-fix-return-start-status-on-fail.patch" "0aiznl18h0pzdbkq3336m7qcxiddl4z0bdjjs99bw2x891ylzw9s")
     (p "${baseURL}/autofs-5.0.4-fix-double-free-in-expire_proc.patch" "113ymh38rjnl7cbd82pijbk9z86p5izkymmr7lzmdbj4k47m85jk")
     (p "${baseURL}/autofs-5.0.4-another-easy-alloca-replacements-fix.patch" "19dik3hx415bbn4b68x5ig48jxhr5mmh3kd4akj82rhslys66l9m")
     (p "${baseURL}/autofs-5.0.4-add-lsb-init-script-parameter-block.patch" "0a2ad0cvcrv051n8ab79sglvb00q8ky8948bzs1nbqycjrfy8a6s")
     
     (p "${baseURL}/autofs-5.0.4-always-read-file-maps-fix.patch" "1w65qg878d076v5m75cm00qvlxqg1v2bpxg0wwx0316jfi8cigf1")
     (p "${baseURL}/autofs-5.0.4-use-misc-device.patch" "18gf57zil7y9i1x288dj68cfhn8hsvq1b9r6aj3xli4y9r8my1ky")
     (p "${baseURL}/autofs-5.0.4-fix-restorecon.patch" "0skbbxakpa521n4yx54ivak9bsn03li681pkvmd92v6g49dzw28d")
     (p "${baseURL}/autofs-5.0.4-clear-rpc-client-on-lookup-fail.patch" "17613x9i5nsc49ly978nc77jkn5rb6kzxcqk41i5qknxraaqypb9")
     (p "${baseURL}/autofs-5.0.4-fix-lsb-init-script-header.patch" "1511sazpg577zmryr6px7xx1vsbq18kvi4pyp0xaxmkp1rsfjp0w")


     (p "${baseURL}/autofs-5.0.4-fix-memory-leak-reading-ldap-master.patch" "10413a04f002chiclgvgbbwgpw4lgj3j40iiic5h2wvcf4dbk2x3")
     (p "${baseURL}/autofs-5.0.4-fix-st_remove_tasks-locking.patch" "15wd4qwk8nmqwvbijznfpdf0anm6r2sjvgqfjyhpw0c768715m63")
     (p "${baseURL}/autofs-5.0.4-reset-flex-scanner-when-setting-buffer.patch" "1ndi3i2zi4c6yfkj1k8jimjwyg2mwvyifddvb56048yby9vp7mc3")
    / * 
     (p "${baseURL}/autofs-5.0.4-zero-s_magic-is-valid.patch" "0izmx7gw5i9d26bipc161a74mvlmr6r0h9glxiplhv1w41lny4nw")
     (p "${baseURL}/autofs-5.0.4-use-percent-hack-for-master.patch" "1pjfs6hcdfklj7w5h0f2h8fiqx78v1l540xn7cy0j6y0jfi3y03d")


        fails on changelog
     (p "${baseURL}/autofs-5.0.4-dont-umount-existing-direct-mount-on-reread.patch" "1n3y033lavpi2sbylrli821srxx9b3vvmwa2rqnd0waa8sms5bzz")
     (p "${baseURL}/autofs-5.0.4-fix-kernel-includes.patch" "1lwn2yi229zby2bkcl1vxyjqh72sy9pwdmriqhcpynfwp7x9i0fa")
     (p "${baseURL}/autofs-5.0.4-use-intr-as-hosts-mount-default.patch" "1sqi5a0b5j6gk6nfi1g88kaf248gaa7fpjrk80cxdm1j6f10qm67")
     (p "${baseURL}/autofs-5.0.4-use-intr-as-hosts-mount-default.patch" "1sqi5a0b5j6gk6nfi1g88kaf248gaa7fpjrk80cxdm1j6f10qm67")
     * /
  ];
  */

in
stdenv.mkDerivation {
  name = "autofs-5.0.4";

  src = /*fetchurl {
    url = "${baseURL}/autofs-5.0.4.tar.bz2";
    sha256 = "06ysv24jwhwvl8vbafy4jxcg9ps1iq5nrz2nyfm6c761rniy27v3";
  }*/ /home/marc/managed_repos/all.tar.gz;

  preConfigure = ''
    configureFlags="--with-path=$PATH"
    export MOUNT=/var/run/current-system/sw/bin/mount
    export MODPROBE=/var/run/current-system/sw/sbin/modprobe
    # Grrr, rpcgen can't find cpp. (NIXPKGS-48)
    mkdir rpcgen
    echo "#! $shell" > rpcgen/rpcgen
    echo "exec $(type -tp rpcgen) -Y $(dirname $(type -tp cpp)) \"\$@\"" >> rpcgen/rpcgen
    chmod +x rpcgen/rpcgen
    export RPCGEN=$(pwd)/rpcgen/rpcgen
  '';

  installPhase = ''
    make install SUBDIRS="lib daemon modules man" # all but samples
    #make install SUBDIRS="samples" # impure!
  '';

  buildInputs = [flex bison kernelHeaders];

  inherit patches;

  meta = { 
    description="Kernel based automounter";
    homepage="http://www.linux-consulting.com/Amd_AutoFS/autofs.html";
    license = "GPLv2";
    executables = [ "automount" ];
  };
}
