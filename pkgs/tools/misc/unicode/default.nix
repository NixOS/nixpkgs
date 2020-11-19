{ stdenv, fetchFromGitHub, fetchurl, python3Packages, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "unicode";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "15d9yvarxsiy0whx1mxzsjnnkrjdm3ga4qv2yy398mk0jh763q9v";
  };

  ucdtxt = fetchurl {
    url = "https://www.unicode.org/Public/13.0.0/ucd/UnicodeData.txt";
    sha256 = "1fz8fcd23lxyl97ay8h42zvkcgcg8l81b2dm05nklkddr2zzpgxx";
  };

  nativeBuildInputs = [ installShellFiles ];

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace "/usr/share/unicode/UnicodeData.txt" "$ucdtxt"
  '';

  postInstall = ''
    installManPage paracode.1 unicode.1
  '';

  meta = with stdenv.lib; {
    description = "Display unicode character properties";
    homepage = "https://github.com/garabik/unicode";
    license = licenses.gpl3;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
  };
}
