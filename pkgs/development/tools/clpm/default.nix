{ lib
, stdenv
, fetchgit
, wrapLisp
, sbcl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "clpm";
  version = "0.4.1";

  src = fetchgit {
    url = "https://gitlab.common-lisp.net/clpm/clpm";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-UhaLmbdsIPj6O+s262HUMxuz/5t43JR+TlOjq8Y2CDs=";
  };

  buildInputs = [
    (wrapLisp sbcl)
  ];

  propagatedBuildInputs = [
    openssl
  ];

  postPatch = ''
    # patch cl-plus-ssl to ensure that it finds libssl and libcrypto
    sed 's|libssl.so|${lib.getLib openssl}/lib/libssl.so|' -i ext/cl-plus-ssl/src/reload.lisp
    sed 's|libcrypto.so|${lib.getLib openssl}/lib/libcrypto.so|' -i ext/cl-plus-ssl/src/reload.lisp
    # patch dexador to avoid error due to dexador being loaded multiple times
    sed -i 's/defpackage/uiop:define-package/g' ext/dexador/src/dexador.lisp
  '';

  buildPhase = ''
    runHook preBuild

    # exporting home to avoid using /homeless-shelter/.cache/ as this will cause
    # ld to complaing about `impure path used in link`.
    export HOME=$TMP

    common-lisp.sh --script scripts/build-release.lisp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cd build/release-staging/dynamic/clpm-${version}*/
    INSTALL_ROOT=$out/ bash install.sh

    runHook postInstall
  '';

  # fixupPhase results in fatal error in SBCL, `Can't find sbcl.core`
  dontFixup = true;

  meta = with lib; {
    description = "Common Lisp Package Manager";
    homepage = "https://www.clpm.dev/";
    license = licenses.bsd2;
    maintainers = [ maintainers.petterstorvik ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
