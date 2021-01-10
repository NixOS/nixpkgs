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
    url = "https://gitlab.common-lisp.net/clpm/clpm";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0jivnnp3z148yf4c2nzzr5whz76w5kjhsb97z2vs5maiwf79y2if";
  };

  buildInputs = [
    (wrapLisp sbcl)
    openssl
  ];

  buildPhase = ''
    ln -s ${openssl.out}/lib/libcrypto.so.* .
    ln -s ${openssl.out}/lib/libssl.so.* .
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
