{ stdenv
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "isolyzer";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "KBNLresearch";
    repo = pname;
    rev = version;
    sha256 = "1fysm05cz0z54apn1p889xhbgjnfwax6fngi05yij5qp2zxqghf9";
  };

  propagatedBuildInputs = with python3.pkgs; [ setuptools six ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/KBNLresearch/isolyzer";
    description = "Verify size of ISO 9660 image against Volume Descriptor fields";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
