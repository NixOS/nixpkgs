{ gcc9Stdenv, lib, fetchFromGitLab, autoreconfHook, libpcap, db, glib, libnet, libnids, symlinkJoin, openssl
, rpcsvc-proto, libtirpc, libnsl
}:

# We compile with GCC 9 since GCC 10 segfaults on the code
# (see https://bugzilla.redhat.com/show_bug.cgi?id=1862809).

let
  /*
  dsniff's build system unconditionnaly wants static libraries and does not
  support multi output derivations. We do some overriding to give it
  satisfaction.
  */
  staticdb = symlinkJoin {
    inherit (db) name;
    paths = with db.overrideAttrs(old: { dontDisableStatic = true; }); [ out dev ];
    postBuild = ''
      rm $out/lib/*.so*
    '';
  };
  pcap = symlinkJoin {
    inherit (libpcap) name;
    paths = [ (libpcap.overrideAttrs(old: { dontDisableStatic = true; })) ];
    postBuild = ''
      cp -rs $out/include/pcap $out/include/net
      # prevent references to libpcap
      rm $out/lib/*.so*
    '';
  };
  net = symlinkJoin {
    inherit (libnet) name;
    paths = [ (libnet.overrideAttrs(old: { dontDisableStatic = true; })) ];
    postBuild = ''
      # prevent dynamic linking, now that we have a static library
      rm $out/lib/*.so*
    '';
  };
  nids = libnids.overrideAttrs(old: {
    dontDisableStatic = true;
  });
  ssl = symlinkJoin {
    inherit (openssl) name;
    paths = with openssl.override { static = true; }; [ out dev ];
  };
in gcc9Stdenv.mkDerivation rec {
  pname = "dsniff";
  version = "2.4b1";
  # upstream is so old that nearly every distribution packages the beta version.
  # Also, upstream only serves the latest version, so we use debian's sources.
  # this way we can benefit the numerous debian patches to be able to build
  # dsniff with recent libraries.
  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "pkg-security-team";
    repo = "dsniff";
    rev = "debian/${version}+debian-30";
    sha256 = "1fk2k0sfdp5g27i11g0sbzm7al52raz5yr1aibzssnysv7l9xgzh";
    name = "dsniff.tar.gz";
  };

  nativeBuildInputs = [ autoreconfHook rpcsvc-proto ];
  buildInputs = [ glib pcap libtirpc libnsl ];
  NIX_CFLAGS_LINK = "-lglib-2.0 -lpthread -ltirpc";
  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];
  postPatch = ''
    for patch in debian/patches/*.patch; do
      patch < $patch
    done;
  '';
  configureFlags = [
    "--with-db=${staticdb}"
    "--with-libpcap=${pcap}"
    "--with-libnet=${net}"
    "--with-libnids=${nids}"
    "--with-openssl=${ssl}"
  ];

  meta = with lib; {
    description = "collection of tools for network auditing and penetration testing";
    longDescription = ''
      dsniff, filesnarf, mailsnarf, msgsnarf, urlsnarf, and webspy passively monitor a network for interesting data (passwords, e-mail, files, etc.). arpspoof, dnsspoof, and macof facilitate the interception of network traffic normally unavailable to an attacker (e.g, due to layer-2 switching). sshmitm and webmitm implement active monkey-in-the-middle attacks against redirected SSH and HTTPS sessions by exploiting weak bindings in ad-hoc PKI.
    '';
    homepage = "https://www.monkey.org/~dugsong/dsniff/";
    license = licenses.bsd3;
    maintainers = [ maintainers.symphorien ];
    # bsd and solaris should work as well
    platforms = platforms.linux;
  };
}
