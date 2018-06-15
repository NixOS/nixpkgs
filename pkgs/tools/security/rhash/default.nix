{ stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  version = "2018-02-05";
  name = "rhash-${version}";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "cc26d54ff5df0f692907a5e3132a5eeca559ed61";
    sha256 = "1ldagp931lmxxpyvsb9rrar4iqwmv94m6lfjzkbkshpmk3p5ng7h";
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
