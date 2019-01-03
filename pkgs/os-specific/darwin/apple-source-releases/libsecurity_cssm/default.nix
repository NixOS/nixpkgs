{ appleDerivation, libsecurity_cdsa_client, libsecurity_cdsa_plugin, libsecurity_cdsa_utilities, libsecurity_utilities, perl }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
    libsecurity_cdsa_client
    perl
    libsecurity_cdsa_plugin
  ];
  preBuild = ''
    mkdir derived_src
    perl lib/generator.pl lib lib/generator.cfg derived_src
  '';
}