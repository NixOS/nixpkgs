{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nmfd";
  version = "1.1.3";
  src = fetchFromGitHub {
    owner = "Ameliorate";
    repo = "nmfd";
    rev = "v${version}";
    sha256 = "1gk3kz9m8547yn9w7cr4a3nlg5pq7z86mksv2ayrmvcicm6m0ifc";
  };

  makeFlags = [ "INSTALL_PATH=$(out)/bin/" "MANUAL_PATH=$(out)/share/man/man1" ];

  preBuild = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    '';

  meta = with stdenv.lib; {
    description = "A simple utility to watch the state of the side-buttons on most models of Razer Naga mice";
    homepage = https://github.com/Ameliorate/nmfd;
    license = licenses.mit;
    maintainers = [ maintainers.amelorate ];
    platforms = platforms.all;
  };
}
