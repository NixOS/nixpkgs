{ lib, stdenv, fetchFromGitHub, curl, autoconf, automake, makeWrapper, sbcl }:

stdenv.mkDerivation rec {
  pname = "roswell";
  version = "21.05.14.109";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r4r2d0jfwqaxjfnzwl804g194hjrn6lma485crb4gxs7xkziwbx";
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
