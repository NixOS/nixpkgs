{ appleDerivation, libsecurity_cdsa_client, libsecurity_cdsa_plugin, libsecurity_cdsa_utilities, libsecurity_utilities, libsecurityd }:
appleDerivation {
  buildInputs = [
    libsecurity_cdsa_plugin
    libsecurity_utilities
    libsecurity_cdsa_utilities
    libsecurityd
    libsecurity_cdsa_client
  ];
}
