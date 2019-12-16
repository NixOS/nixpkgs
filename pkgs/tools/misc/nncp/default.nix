{ stdenv
, go
, fetchurl
, curl
, perl
, genericUpdater
, writeShellScript
}:

stdenv.mkDerivation rec {
  pname = "nncp";
  version = "5.3.3";

  src = fetchurl {
    url = "http://www.nncpgo.org/download/${pname}-${version}.tar.xz";
    sha256 = "1l35ndzrvpfim29jn1p0bwmc8w892z44nsrdnay28k229r9dhz3h";
  };

  nativeBuildInputs = [ go ];

  preConfigure = ''
    export GOCACHE=$PWD/.cache
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CFGPATH=/etc/nncp.hjson"
    "SENDMAIL=/run/wrappers/bin/sendmail"
  ];

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = writeShellScript "nncp-versionLister" ''
      echo "# Versions for $1:" >> "$2"
      ${curl}/bin/curl -s http://www.nncpgo.org/Tarballs.html | ${perl}/bin/perl -lne 'print $1 if /Release.*>([0-9.]+)</'
    '';
  };

  meta = with stdenv.lib; {
    description = "Secure UUCP-like store-and-forward exchanging";
    longDescription = ''
      This utilities are intended to help build up small size (dozens of
      nodes) ad-hoc friend-to-friend (F2F) statically routed darknet
      delay-tolerant networks for fire-and-forget secure reliable files,
      file requests, Internet mail and commands transmission. All
      packets are integrity checked, end-to-end encrypted, explicitly
      authenticated by known participants public keys. Onion encryption
      is applied to relayed packets. Each node acts both as a client and
      server, can use push and poll behaviour model.

      Out-of-box offline sneakernet/floppynet, dead drops, sequential
      and append-only CD-ROM/tape storages, air-gapped computers
      support. But online TCP daemon with full-duplex resumable data
      transmission exists.
    '';
    homepage = "http://www.nncpgo.org/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.woffs ];
  };
}
