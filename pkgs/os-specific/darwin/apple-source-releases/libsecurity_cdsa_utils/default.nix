{ Security, appleDerivation, apple_sdk, cppcheck, libsecurity_cdsa_utilities, libsecurity_utilities, m4, osx_private_sdk }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
    m4
  ];
}
