{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fierce";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mschwager";
    repo = pname;
    rev = version;
    sha256 = "11yaz8ap9swx95j3wpqh0b6jhw6spqgfnsyn1liw9zqi4jwgiax7";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace 'dnspython==1.16.0' 'dnspython'
  '';

  propagatedBuildInputs = [ python3.pkgs.dnspython ];

  # tests require network access
  doCheck = false;
  pythonImportsCheck = [ "fierce" ];

  meta = with lib; {
    homepage = "https://github.com/mschwager/fierce";
    description = "DNS reconnaissance tool for locating non-contiguous IP space";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
