{ appleDerivation, bootstrap_cmds, libsecurity_cdsa_client, libsecurity_cdsa_utilities, libsecurity_utilities }:
appleDerivation {
  buildInputs = [
    libsecurity_cdsa_utilities
    libsecurity_utilities
    bootstrap_cmds
  ];
  patchPhase = ''
    unpackFile ${libsecurity_cdsa_client.src}
    mv libsecurity_cdsa_client*/lib security_cdsa_client
    ln -s lib securityd_client

    patch -p1 < ${./xdr-arity.patch}
  '';
  preBuild = ''
    make -f mig/mig.mk SRCROOT=. BUILT_PRODUCTS_DIR=.
    cp derived_src/* lib
    rm lib/ucspClientC.c
  '';
  postFixup = ''
    ln -s $dev/include/securityd $dev/include/securityd_client
  '';
}
