{ appleDerivation, libsecurity_cdsa_utilities, libsecurity_utilities, libsecurityd }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
    libsecurityd
  ];
}
