{ stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "kzipmix";
  version = "20200115";

  src = fetchurl {
    url = "https://www.jonof.id.au/files/kenutils/kzipmix-${version}-linux.tar.gz";
    sha256 = "086z8jzl56dk0hwgaj3vwy6n924xrgvwayiwvzwl1z7s81xk5y3q";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out/bin
    cp amd64/{kzip,zipmix} $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tool that aggressively optimizes the sizes of Zip archives";
    homepage = "https://www.jonof.id.au/kenutils.html";
    license = licenses.unfree;
    maintainers = [ maintainers.sander ];
  };
}
