{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "OSXPrivateSDK";

  src = fetchFromGitHub {
    owner = "samdmarshall";
    repo = "OSXPrivateSDK";
    rev = "f4d52b60e86b496abfaffa119a7d299562d99783";
    sha256 = "0bv0884yxpvk2ishxj8gdy1w6wb0gwfq55q5qjp0s8z0z7f63zqh";
  };

  # NOTE: we install only headers that are really needed to keep closure sie
  # reasonable.
  installPhase = ''
    mkdir -p $out/include
    sdk10=PrivateSDK10.10.sparse.sdk
    sdk=PrivateSDK10.9.sparse.sdk
    cp $sdk/usr/local/include/sandbox_private.h $out/include/sandbox_private.h
    # this can be removed once we dtrace binary
    cp $sdk/usr/local/include/security_utilities/utilities_dtrace.h $out/include/utilities_dtrace.h
    cp -RL $sdk/usr/include/xpc $out/include/xpc
    cp -RL $sdk/usr/local/include/bsm $out/include/bsm
    cp -RL $sdk/System/Library/Frameworks/Security.framework/Versions/A/PrivateHeaders $out/include/SecurityPrivateHeaders
    cp -RL $sdk10/System/Library/Frameworks/CoreFoundation.framework/Headers $out/include/CoreFoundationPrivateHeaders
  '';
}
