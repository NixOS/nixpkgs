{ stdenv, fetchFromGitHub, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "unicode-${version}";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "17hh4nwl5njsh7lnff583j2axn6rfvfbiqwp72n7vcsgkiszw4kg";
  };

  ucdtxt = fetchurl {
    url = http://www.unicode.org/Public/11.0.0/ucd/UnicodeData.txt;
    sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
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
    platforms = platforms.all;
  };
}
