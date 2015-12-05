{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "simp_le-20151205";

  src = fetchFromGitHub {
    owner = "kuba";
    repo = "simp_le";
    rev = "976a33830759e66610970f92f6ec1a656a2c8335";
    sha256 = "0bfa5081rmjjg9sii6pn2dskd1wh0dgrf9ic9hpisawrk0y0739i";
  };

  propagatedBuildInputs = with pythonPackages; [ acme cryptography pytz requests2 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kuba/simp_le;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
