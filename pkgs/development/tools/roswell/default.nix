{ lib, stdenv, fetchFromGitHub, curl, autoconf, automake, makeWrapper, sbcl }:

stdenv.mkDerivation rec {
  pname = "roswell";
  version = "21.06.14.110";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = pname;
    rev = "v${version}";
    sha256 = "18hxhz7skxvzabz5z0yjky4f3fsyfanafh0imkn5macp8aw3wsfm";
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
