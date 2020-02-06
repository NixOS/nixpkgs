{ stdenv, fetchFromGitLab, autoreconfHook, libpcap, db, glib, libnet, libnids, symlinkJoin, openssl }:
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
    paths = [ libpcap ];
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
in stdenv.mkDerivation {
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
    rev = "debian%2F2.4b1%2Bdebian-29"; # %2B = urlquote("+"), %2F = urlquote("/")
    sha256 = "10zz9krf65jsqvlcr72ycp5cd27xwr18jkc38zqp2i4j6x0caj2g";
    name = "dsniff.tar.gz";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ glib pcap ];
  NIX_CFLAGS_LINK = "-lglib-2.0 -lpthread -ldl";
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

  meta = with stdenv.lib; {
    description = "collection of tools for network auditing and penetration testing";
    longDescription = ''
      dsniff, filesnarf, mailsnarf, msgsnarf, urlsnarf, and webspy passively monitor a network for interesting data (passwords, e-mail, files, etc.). arpspoof, dnsspoof, and macof facilitate the interception of network traffic normally unavailable to an attacker (e.g, due to layer-2 switching). sshmitm and webmitm implement active monkey-in-the-middle attacks against redirected SSH and HTTPS sessions by exploiting weak bindings in ad-hoc PKI.
    '';
    homepage = https://www.monkey.org/~dugsong/dsniff/;
    license = licenses.bsd3;
    maintainers = [ maintainers.symphorien ];
    # bsd and solaris should work as well
    platforms = platforms.linux;
  };
}
