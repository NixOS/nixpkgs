{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "ariang";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/mayswind/AriaNg/releases/download/${version}/AriaNg-${version}.zip";
    sha256 = "1hc6hz6a4l4qc8hgq08ihdcba8dkjki4cxc2kx22fy6dd67997f9";
  };
  sourceRoot = ".";
  buildInputs = [ unzip ];

  installPhase = ''
    mkdir $out
    cp -ra * $out/
  '';

  meta = with stdenv.lib; {
    description = "Modern web frontend making aria2 easier to use";
    license = licenses.mit;
    homepage = "http://ariang.mayswind.net/";
    maintainers = with maintainers; [ dawidsowa ];
  };
}
