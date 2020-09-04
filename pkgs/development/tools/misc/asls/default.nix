{ stdenv
, fetchurl
, erlangR22
}:

stdenv.mkDerivation rec {
  pname = "asls";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/saulecabrera/asls/releases/download/v${version}/bin.tar.gz";
    sha256 = "1h6r2lbf54aylzmbiy74ys42fhjv9q824bdrcp40gxx1v2yjc5h5";
  };

  buildInputs = [ erlangR22 ];
  installPhase = "install -Dm755 -t $out/bin asls";

  meta = with stdenv.lib; {
    description = "AssemblyScript Language Server";
    homepage = "https://github.com/saulecabrera/asls";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ saulecabrera ];
  };
}
