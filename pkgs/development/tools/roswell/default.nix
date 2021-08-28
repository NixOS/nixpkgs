{ lib, stdenv, fetchFromGitHub, curl, autoconf, automake, makeWrapper, sbcl }:

stdenv.mkDerivation rec {
  pname = "roswell";
  version = "21.01.14.108";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hj9q3ig7naky3pb3jkl9yjc9xkg0k7js3glxicv0aqffx9hkp3p";
  };

  preConfigure = ''
    sh bootstrap
  '';

  configureFlags = [ "--prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/ros \
      --add-flags 'lisp=sbcl-bin/system sbcl-bin.version=system' \
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
