{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "lcdf-typetools";
  version = "2.108";

  src = fetchFromGitHub {
    owner = "kohler";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a6jqaqwq43ldjjjlnsh6mczs2la9363qav7v9fyrfzkfj8kw9ad";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--without-kpathsea" ];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating OpenType, PostScript Type 1, and Multiple Master fonts";
    homepage = "https://www.lcdf.org/type";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
