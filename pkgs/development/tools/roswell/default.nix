{ lib, stdenv, fetchFromGitHub, curl, autoconf, automake, makeWrapper, sbcl }:

stdenv.mkDerivation rec {
  pname = "roswell";
  version = "21.10.14.111";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K4RDNTY8g6MNjjiwXMmYaZm0fChJ1C1eTpc0h7ja1ds=";
  };

  patches = [
    # Load the name of the image from the environment variable so that
    # it can be consistently overwritten. Using the command line
    # argument in the wrapper did not work.
    ./0001-get-image-from-environment.patch
  ];

  preConfigure = ''
    sh bootstrap
  '';

  configureFlags = [ "--prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/ros \
      --set image `basename $out` \
      --add-flags 'lisp=sbcl-bin/system sbcl-bin.version=system -L sbcl-bin' \
      --prefix PATH : ${lib.makeBinPath [ sbcl ]} --argv0 ros
  '';

  nativeBuildInputs = [ autoconf automake makeWrapper ];

  buildInputs = [ sbcl curl ];

  meta = with lib; {
    description = "Roswell is a Lisp implementation installer/manager, launcher, and much more";
    license = licenses.mit;
    maintainers = with maintainers; [ hiro98 ];
    platforms = platforms.linux;
    homepage = "https://github.com/roswell/roswell";
    mainProgram = "ros";
  };
}
