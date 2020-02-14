{ stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  version = "1.3.9";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "06i49x1l21h2q7pfnf4crbmjyg8b9ad0qs10ywyyn5sjpi0c21wq";
  };

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  configurePlatforms = [ ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [ "install" "install-lib-shared" "install-lib-so-link" "install-lib-headers" ];

  meta = with stdenv.lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
