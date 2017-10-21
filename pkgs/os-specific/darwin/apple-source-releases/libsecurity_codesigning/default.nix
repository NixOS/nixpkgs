{ appleDerivation, libsecurity_cdsa_utilities, libsecurity_utilities }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
  ];
}