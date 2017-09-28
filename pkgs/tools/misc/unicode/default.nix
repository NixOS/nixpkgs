{ stdenv, fetchFromGitHub, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "unicode-${version}";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "0vg1zshlzgdva8gzw6fya28fc4jhypjkj743x3q0yabx6934k0g2";
  };

  ucdtxt = fetchurl {
    url = http://www.unicode.org/Public/11.0.0/ucd/UnicodeData-11.0.0d1.txt;
    sha256 = "0y9l0sap7yq7c7c8d0fivzycqaw0zncbxzh1inggg42308z974rn";
  };

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace "/usr/share/unicode/UnicodeData.txt" "$ucdtxt"
  '';

  meta = with stdenv.lib; {
    description = "Display unicode character properties";
    homepage = https://github.com/garabik/unicode;
    license = licenses.gpl3;
    maintainers = [ maintainers.woffs ];
  };
}
