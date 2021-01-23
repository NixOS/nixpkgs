{ fetchgit, lib, stdenv, pkg-config, libnsl, libtirpc, autoreconfHook
, useSystemd ? true, systemd }:

stdenv.mkDerivation {
  pname = "rpcbind";
  version = "1.2.5";

  src = fetchgit {
    url = "git://git.linux-nfs.org/projects/steved/rpcbind.git";
    rev = "c0c89b3bf2bdf304a5fe3cab626334e0cdaf1ef2";
    sha256 = "1k5rr0pia70ifyp877rbjdd82377fp7ii0sqvv18qhashr6489va";
  };

  patches = [
    ./sunrpc.patch
  ];

  buildInputs = [ libnsl libtirpc ]
             ++ lib.optional useSystemd systemd;

  configureFlags = [
    "--with-systemdsystemunitdir=${if useSystemd then "${placeholder "out"}/etc/systemd/system" else "no"}"
    "--enable-warmstarts"
    "--with-rpcuser=rpc"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "ONC RPC portmapper";
    license = licenses.bsd3;
    platforms = platforms.unix;
    homepage = "https://linux-nfs.org/";
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
