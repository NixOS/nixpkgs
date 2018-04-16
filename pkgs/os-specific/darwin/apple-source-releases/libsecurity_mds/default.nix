{ appleDerivation, libsecurity_cdsa_client, libsecurity_cdsa_plugin, libsecurity_cdsa_utilities, libsecurity_filedb, libsecurity_utilities, libsecurityd }:
appleDerivation {
  buildInputs = [
    libsecurity_cdsa_plugin
    libsecurity_cdsa_utilities
    libsecurity_filedb
    libsecurity_utilities
    libsecurity_cdsa_client
    libsecurityd
  ];
  postInstall = ''
    ln -s $out/include/security_mds $out/include/Security
  '';
}
