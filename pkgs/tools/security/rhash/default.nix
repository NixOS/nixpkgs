{ stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  version = "1.3.6";
  name = "rhash-${version}";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "1c8gngjj34ylx1f56hjbvml22bif0bx1b88dx2cyxbix8praxqh7";
  };

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  configurePlatforms = [ ];

  doCheck = false; # fails

  installTargets = [ "install" "install-lib-shared" "install-lib-so-link" ];
  postInstall = "make -C librhash install-headers";

  meta = with stdenv.lib; {
    homepage = http://rhash.anz.ru;
    description = "Console utility and library for computing and verifying hash sums of files";
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
