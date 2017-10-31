{ Security, appleDerivation, libsecurity_cdsa_utilities, libsecurity_utilities, m4 }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
    m4
  ];
}
