{ stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  version = "1.3.8";
  name = "rhash-${version}";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "0i00wl63hn80g0s9gdi772gchbghwgkvn4nbb5227y2wwy30yyi2";
  };

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  configurePlatforms = [ ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [ "install" "install-lib-shared" "install-lib-so-link" "install-lib-headers" ];

  meta = with stdenv.lib; {
    homepage = http://rhash.anz.ru;
    description = "Console utility and library for computing and verifying hash sums of files";
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
