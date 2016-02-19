{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2016-01-09";

  src = fetchFromGitHub {
    owner = "kuba";
    repo = "simp_le";
    rev = "b9d95e862536d1242e1ca6d7dac5691f32f11373";
    sha256 = "0l4qs0y4cbih76zrpbkn77xj17iwsm5fi83zc3p048x4hj163805";
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
