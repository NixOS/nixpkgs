{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2016-04-17";

  src = fetchFromGitHub {
    owner = "kuba";
    repo = "simp_le";
    rev = "3a103b76f933f9aef782a47401dd2eff5057a6f7";
    sha256 = "0x8gqazn09m30bn1l7xnf8snhbb7yz7sb09imciqmm4jqdvn797z";
  };

  propagatedBuildInputs = with pythonPackages; [ acme ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
