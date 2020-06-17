{ stdenv, fetchFromGitHub }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "ae61d2778b0a0f47461a52da0d1f191f651e0763";
    sha256 = "0j6bpwz49skvdvian46valjw4anwlrnkq703n0snkbngmq78prba";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware/intel

    sed -i 's/ROOT=.*$/ROOT=$out/g' go.sh
    sed -i 's/VERSION=.*$/VERSION=v${version}/g' go.sh

    ./go.sh
  '';

  meta = with stdenv.lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden ];
    platforms = with platforms; linux;
  };
}
