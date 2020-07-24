{ stdenv
, fetchurl
, erlangR22
}:

stdenv.mkDerivation rec {
  pname = "asls";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/saulecabrera/asls/releases/download/v${version}/bin.tar.gz";
    sha256 = "0zy89fvdhk2bj41fzx349gi8237ww96s21hlg6blqmfhvfxsnszg";
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
