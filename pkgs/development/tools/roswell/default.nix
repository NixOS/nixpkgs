{ lib
, stdenv
, fetchFromGitHub
, curl
, autoconf
, automake
, makeWrapper
, sbcl
}:

stdenv.mkDerivation rec {
  pname = "roswell";
  version = "23.10.14.114";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-70BSwRKj1WPvWxQzWPrs8ECkcVosAUaX5cK7FaDUhRc=";
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

  nativeBuildInputs = [
    autoconf
    automake
    makeWrapper
  ];

  buildInputs = [
    sbcl
    curl
  ];

  meta = with lib; {
    description = "Lisp implementation installer/manager and launcher";
    license = licenses.mit;
    maintainers = with maintainers; [ hiro98 ];
    platforms = platforms.unix;
    homepage = "https://github.com/roswell/roswell";
    changelog = "https://github.com/roswell/roswell/blob/v${version}/ChangeLog";
    mainProgram = "ros";
  };
}
