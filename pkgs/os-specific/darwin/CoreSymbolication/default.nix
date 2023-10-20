{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "core-symbolication";
  version = "unstable-2018-04-08";

  src = fetchFromGitHub {
    repo = "CoreSymbolication";
    owner = "matthewbauer";
    rev = "671fcb66c82eac1827f3f53dc4cc4e9b1b94da0a";
    hash = "sha256-0qpw46gwgjxiwqqjxksb8yghp2q8dwad6hzaf4zl82xpvk9n5ahj";
  };

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Reverse engineered headers for Apple's CoreSymbolication framework";
    homepage = "https://github.com/matthewbauer/CoreSymbolication";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
