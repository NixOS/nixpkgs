{ lib, stdenv
, fetchurl
, erlangR22
}:

stdenv.mkDerivation rec {
  pname = "asls";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/saulecabrera/asls/releases/download/v${version}/bin.tar.gz";
    sha256 = "05kp44p4q4sdykfw0b4k9j3qdp0qvwgjbs48ncmnd0ass0xrmi3s";
  };

  nativeBuildInputs = [ erlangR22 ];
  installPhase = "install -Dm755 -t $out/bin asls";

  meta = with lib; {
    description = "AssemblyScript Language Server";
    homepage = "https://github.com/saulecabrera/asls";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ saulecabrera ];
  };
}
