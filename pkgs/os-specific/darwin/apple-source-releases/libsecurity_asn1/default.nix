{ appleDerivation, libsecurity_cdsa_utilities, libsecurity_utilities }:
appleDerivation {
  __propagatedImpureHostDeps = [
    "/System/Library/Frameworks/Security.framework/Security"
    "/System/Library/Frameworks/Security.framework/Resources"
    "/System/Library/Frameworks/Security.framework/PlugIns"
    "/System/Library/Frameworks/Security.framework/XPCServices"
    "/System/Library/Frameworks/Security.framework/Versions"
  ];
  propagatedBuildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
  ];
}
