{ stdenv, fetchFromGitHub, gtk3, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "flips";
  version = "v1.40-pre";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    rev = "3489a85fbf86e9d4ef5e42a6cdf9ec5dd649e50b";
    sha256 = "0ghlg80dwd9cjp86wxf63639g9p7cn9dxflgbq4q5m76yqbws7qb";
  };

  buildInputs = [ gtk3 pkgconfig ];

  postBuild = "mkdir -p $out/bin && mv flips $out/bin";
  dontInstall = true;

  meta = with stdenv.lib; {
    description = "A patcher for IPS and BPS files";
    license = licenses.gpl3;
    maintainers = [ maintainers.djanatyn ];
    homepage = "https://www.romhacking.net/utilities/1040/";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
