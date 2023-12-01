{lib, stdenv, fetchgit}:

stdenv.mkDerivation rec {
  pname = "mdf2iso";
  version = "0.3.1";

  src = fetchgit {
    url    = "https://salsa.debian.org/debian/mdf2iso";
    rev    = "c6a5b588318d43bc8af986bbe48d0a06e92f4280";
    sha256 = "0xg43jlvrk8adfjgbjir15nxwcj0nhz4gxpqx7jdfvhg0kwliq0n";
  };

  meta = with lib; {
    description = "Small utility that converts MDF images to ISO format";
    homepage = src.url;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.oxij ];
    mainProgram = "mdf2iso";
  };
}
