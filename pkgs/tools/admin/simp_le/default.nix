{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2016-02-06";

  src = fetchFromGitHub {
    owner = "kuba";
    repo = "simp_le";
    rev = "8f258bc098a84b7a20c2732536d0740244d814f7";
    sha256 = "1r2c31bhj91n3cjyf01spx52vkqxi5475zzkc9s1aliy3fs3lc4r";
  };

  propagatedBuildInputs = with pythonPackages; [ acme_0_1 ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
