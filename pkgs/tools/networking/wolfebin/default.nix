{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  version = "5.4";
  pname = "wolfebin";
  
  src = fetchFromGitHub {
    owner = "thejoshwolfe";
    repo = "wolfebin";
    rev = version;
    sha256 = "16xj6zz30sn9q05p211bmmsl0i6fknfxf8dssn6knm6nkiym8088";
  };

  buildInputs = [ python ];

  installPhase = ''
    install -m 755 -d $out/bin
    install -m 755 wolfebin $out/bin
    install -m 755 wolfebin_server.py $out/bin/wolfebin_server
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/thejoshwolfe/wolfebin";
    description = "Quick and easy file sharing";
    license = licenses.mit;
    maintainers = [ maintainers.andrewrk ];
    platforms = platforms.all;
  };
}
