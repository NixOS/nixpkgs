{ stdenv
, fetchgit
, wrapLisp
, sbcl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "clpm";
  version = "0.3.5";

  src = fetchgit {
    rev = "v${version}";
    url = "https://gitlab.common-lisp.net/clpm/clpm";
    sha256 = "0jivnnp3z148yf4c2nzzr5whz76w5kjhsb97z2vs5maiwf79y2if";
    fetchSubmodules = true;
  };

  buildInputs = [
    (wrapLisp sbcl)
    openssl
  ];

  libssl = openssl.out;

  buildPhase = ''
    # Libs are copied working directory to avoid error when build script tries to deploy them
    cp $libssl/lib/libcrypto.so.* .
    cp $libssl/lib/libssl.so.* .

    common-lisp.sh --script scripts/build.lisp
  '';

  installPhase = ''
    INSTALL_ROOT=$out sh install.sh
  '';

  # fixupPhase results in fatal error in SBCL, `Can't find sbcl.core`
  dontFixup = true;

  meta = with stdenv.lib; {
    description = "Common Lisp Package Manager";
    homepage = "https://www.clpm.dev/";
    license = licenses.bsd2;
    maintainers = [ maintainers.petterstorvik ];
    platforms = platforms.all;
  };
}
