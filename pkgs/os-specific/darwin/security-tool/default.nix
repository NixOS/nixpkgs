{ CoreServices, Foundation, PCSC, Security, GSS, Kerberos, makeWrapper, apple_sdk,
fetchurl, gnustep, libobjc, libsecurity_apple_csp, libsecurity_apple_cspdl,
libsecurity_apple_file_dl, libsecurity_apple_x509_cl, libsecurity_apple_x509_tp,
libsecurity_asn1, libsecurity_cdsa_client, libsecurity_cdsa_plugin,
libsecurity_cdsa_utilities, libsecurity_cdsa_utils, libsecurity_cssm, libsecurity_filedb,
libsecurity_keychain, libsecurity_mds, libsecurity_pkcs12, libsecurity_sd_cspdl,
libsecurity_utilities, libsecurityd, osx_private_sdk, Security-framework, stdenv }:

stdenv.mkDerivation rec {
  version = "55115";
  name = "SecurityTool-${version}";

  src = fetchurl {
    url = "http://opensource.apple.com/tarballs/SecurityTool/SecurityTool-${version}.tar.gz";
    sha256 = "0apcz4vy2z5645jhrs60wj3w27mncjjqv42h5lln36g6qs2n9113";
  };

  patchPhase = ''
    # copied from libsecurity_generic
    ln -s ${osx_private_sdk}/PrivateSDK10.9.sparse.sdk/System/Library/Frameworks/Security.framework/Versions/A/PrivateHeaders Security

    substituteInPlace cmsutil.c --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h>' \
      '"${apple_sdk.sdk}/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers/MacErrors.h"'
    substituteInPlace createFVMaster.c --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h>' \
      '"${apple_sdk.sdk}/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers/MacErrors.h"'
  '';

  postUnpack = ''
    unpackFile ${Security.src}
    cp Security-*/utilities/src/fileIo.c SecurityTool*
    cp Security-*/utilities/src/fileIo.h SecurityTool*
  '';

  preBuild = ''
    makeFlagsArray=(-j''$NIX_BUILD_CORES)
  '';

  NIX_LDFLAGS = "-no_dtrace_dof";

  makeFlags = [
    "-f ${./GNUmakefile}"
    "MAKEFILE_NAME=${./GNUmakefile}"
    "GNUSTEP_MAKEFILES=${gnustep.make}/share/GNUstep/Makefiles"
  ];

  installFlags = [
    "security_INSTALL_DIR=\$(out)/bin"
  ];

  propagatedBuildInputs = [ GSS Kerberos Security-framework PCSC Foundation ];

  __propagatedImpureHostDeps = [ "/System/Library/Keychains" ];

  buildInputs = [
    gnustep.make
    libsecurity_asn1
    libsecurity_utilities
    libsecurity_cdsa_utilities
    libobjc
    libsecurity_cdsa_client
    libsecurity_keychain
    libsecurity_cssm
    libsecurity_cdsa_utils
    libsecurity_mds
    libsecurity_cdsa_plugin
    libsecurity_apple_csp
    libsecurity_apple_cspdl
    libsecurity_apple_file_dl
    libsecurity_apple_x509_cl
    libsecurity_apple_x509_tp
    libsecurity_pkcs12
    libsecurity_sd_cspdl
    libsecurity_filedb
    libsecurityd
    makeWrapper
  ];

  NIX_CFLAGS_COMPILE = [
    "-F${Security}/Library/Frameworks"
    "-F${PCSC}/Library/Frameworks"
    "-Wno-deprecated-declarations"
  ];

  postInstall = ''
    wrapProgram $out/bin/security --set DYLD_INSERT_LIBRARIES /usr/lib/libsqlite3.dylib
  '';

  meta = with stdenv.lib; {
    description = "Command line interface to macOS keychains and Security framework";
    maintainers = with maintainers; [
      copumpkin
      joelteon
    ];
    platforms = platforms.darwin;
    license = licenses.apsl20;
  };
}

