{stdenv, fetchFromGitHub, libX11}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "wayv";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "mikemb";
    repo = pname;
    rev = "b716877603250f690f08b593bf30fd5e8a93a872";
    sha256 = "046dvaq6na1fyxz5nrjg13aaz6ific9wbygck0dknqqfmmjrsv3b";
  };

  buildInputs = [ libX11 ];

  meta = {
    inherit version;
    description = "A gesture control for X11";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/mikemb/wayV";
  };
}
