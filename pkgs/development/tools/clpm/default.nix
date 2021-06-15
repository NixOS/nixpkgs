{ lib
, stdenv
, fetchgit
, wrapLisp
, sbcl_2_0_9
, openssl
}:

stdenv.mkDerivation rec {
  pname = "clpm";
  version = "0.3.6";

  src = fetchgit {
    url = "https://gitlab.common-lisp.net/clpm/clpm";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "04w46yhv31p4cfb84b6qvyfw7x5nx6lzyd4yzhd9x6qvb7p5kmfh";
  };

  buildInputs = [
    (wrapLisp sbcl_2_0_9)
    openssl
  ];

  buildPhase = ''
    runHook preBuild

    ln -s ${openssl.out}/lib/libcrypto*${stdenv.hostPlatform.extensions.sharedLibrary}* .
    ln -s ${openssl.out}/lib/libssl*${stdenv.hostPlatform.extensions.sharedLibrary}* .
    common-lisp.sh --script scripts/build.lisp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    INSTALL_ROOT=$out sh install.sh

    runHook postInstall
  '';

  # fixupPhase results in fatal error in SBCL, `Can't find sbcl.core`
  dontFixup = true;

  meta = with lib; {
    description = "Common Lisp Package Manager";
    homepage = "https://www.clpm.dev/";
    license = licenses.bsd2;
    maintainers = [ maintainers.petterstorvik ];
    platforms = platforms.all;
  };
}
