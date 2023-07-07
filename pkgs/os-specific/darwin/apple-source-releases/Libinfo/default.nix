{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    substituteInPlace xcodescripts/install_files.sh \
      --replace "/usr/local/" "/" \
      --replace "/usr/" "/" \
      --replace '-o "$INSTALL_OWNER" -g "$INSTALL_GROUP"' "" \
      --replace "ln -h" "ln -n"

    export DSTROOT=$out
    sh xcodescripts/install_files.sh
  '';

  appleHeaders = ''
    aliasdb.h
    bootparams.h
    configuration_profile.h
    grp.h
    ifaddrs.h
    ils.h
    kvbuf.h
    libinfo.h
    libinfo_muser.h
    membership.h
    membershipPriv.h
    netdb.h
    netdb_async.h
    ntsid.h
    printerdb.h
    pwd.h
    rpc/auth.h
    rpc/auth_unix.h
    rpc/clnt.h
    rpc/pmap_clnt.h
    rpc/pmap_prot.h
    rpc/pmap_rmt.h
    rpc/rpc.h
    rpc/rpc_msg.h
    rpc/svc.h
    rpc/svc_auth.h
    rpc/types.h
    rpc/xdr.h
    rpcsvc/yp_prot.h
    rpcsvc/ypclnt.h
    si_data.h
    si_module.h
    thread_data.h
  '';
}
