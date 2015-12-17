{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "simp_le-20151207";

  src = fetchFromGitHub {
    owner = "kuba";
    repo = "simp_le";
    rev = "ac836bc0af988cb14dc0a83dc2039e7fa541b677";
    sha256 = "0r07mlis81n0pmj74wjcvjpi6i3lkzs6hz8iighhk8yymn1a8rbn";
  };

  propagatedBuildInputs = with pythonPackages; [ acme ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kuba/simp_le;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
