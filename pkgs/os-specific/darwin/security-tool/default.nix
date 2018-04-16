{ CoreServices, Foundation, PCSC, Security, GSS, Kerberos, makeWrapper
, fetchurl, libsecurity_apple_csp
, libsecurity_apple_cspdl, libsecurity_apple_file_dl, libsecurity_apple_x509_cl
, libsecurity_apple_x509_tp, libsecurity_asn1, libsecurity_cdsa_client
, libsecurity_cdsa_plugin, libsecurity_cdsa_utilities
, libsecurity_cdsa_utils, libsecurity_cssm, libsecurity_filedb
, libsecurity_keychain, libsecurity_mds, libsecurity_pkcs12
, libsecurity_sd_cspdl, libsecurity_utilities, libsecurityd
, osx_private_sdk, Security-framework, stdenv, libsecurity_comcryption
, libsecurity_codesigning, libsecurity_cryptkit, libsecurity_smime
, xcbuild, CarbonHeaders-full}:

stdenv.mkDerivation rec {
  version = "55115";
  name = "SecurityTool-${version}";

  src = fetchurl {
    url = "http://opensource.apple.com/tarballs/SecurityTool/SecurityTool-${version}.tar.gz";
    sha256 = "0apcz4vy2z5645jhrs60wj3w27mncjjqv42h5lln36g6qs2n9113";
  };

  patchPhase = ''
    # copied from libsecurity_generic
    cp -R ${osx_private_sdk}/include/SecurityPrivateHeaders Security

    substituteInPlace cmsutil.c --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h>' \
      '"${CarbonHeaders-full}/include/MacErrors.h"'
    substituteInPlace createFVMaster.c --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h>' \
      '"${CarbonHeaders-full}/include/MacErrors.h"'
    substituteInPlace authz.c \
      --replace '<Security/AuthorizationPriv.h>' '"Security/AuthorizationPriv.h"'
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

  propagatedBuildInputs = [ GSS Kerberos Security-framework PCSC Foundation ];

  __propagatedImpureHostDeps = [ "/System/Library/Keychains" ];

  buildInputs = [
    libsecurity_asn1
    libsecurity_utilities
    libsecurity_cdsa_utilities
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
    libsecurity_comcryption
    libsecurity_cryptkit
    xcbuild
    libsecurity_codesigning
    libsecurity_smime
  ];

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
