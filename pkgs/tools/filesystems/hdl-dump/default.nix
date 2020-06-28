{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  version = "unstable-2020-02-05";
  pname = "hdl-dump";

  src = fetchFromGitHub {
    owner = "AKuHAK";
    repo  = "hdl-dump";
    rev = "b0d74679eaeb404cdfd5c43ec8fd18d9e2bbb038";
    sha256 = "1k6m4px14cr0i8f4fpk4f1wp0sk4isbnbhib1vl7r4yg7564y1j1";
  };

  makeFlags = [ "DEBUG=no" ];

  installPhase = ''
    mkdir -p $out/bin
    cp hdl_dump $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tool to install Playstation 2 games";
    homepage = "https://github.com/AKuHAK/hdl-dump";
    license = licenses.gpl2;
    maintainers = [ maintainers.nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
