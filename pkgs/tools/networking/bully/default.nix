{ lib, stdenv, fetchFromGitHub, libpcap }:

stdenv.mkDerivation rec {
  pname = "bully";
  version = "1.4-00";

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "bully";
    rev = version;
    sha256 = "1n2754a5z44g414a0hj3cmi9q5lwnzyvmvzskrj2nci8c8m2kgnf";
  };

  buildInputs = [ libpcap ];

  enableParallelBuilding = true;

  sourceRoot = "${src.name}/src";

  installPhase = ''
    install -Dm555 -t $out/bin bully
    install -Dm444 -t $out/share/doc/${pname} ../*.md
  '';

  meta = with lib; {
    description = "Retrieve WPA/WPA2 passphrase from a WPS enabled access point";
    homepage = "https://github.com/kimocoder/bully";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
