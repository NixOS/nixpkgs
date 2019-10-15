{ stdenv, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fierce";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mschwager";
    repo = pname;
    rev = version;
    sha256 = "0cdp9rpabazyfnks30rsf3qfdi40z1bkspxk4ds9bm82kpq33jxy";
  };

  propagatedBuildInputs = [ python3.pkgs.dns ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mschwager/fierce";
    description = "DNS reconnaissance tool for locating non-contiguous IP space";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
