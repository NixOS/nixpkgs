{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2017-01-30";

  # kuba/simp_le seems unmaintained
  src = fetchFromGitHub {
    owner = "zenhack";
    repo = "simp_le";
    rev = "95b36cd5333651d767e681e9b5d9acf869da87cf";
    sha256 = "0593v00ycbpldqw0zn7jigb5fk9hwh1s3r7kwlzafd5hhr9924y1";
  };

  propagatedBuildInputs = with pythonPackages; [ acme ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx pradeepchhetri ];
    platforms = platforms.all;
  };
}
