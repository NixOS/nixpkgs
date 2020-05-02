{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "bashcards";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "rpearce";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zbijbcm9lrqwiax37li0jjqcaxf469wh5d423frain56z1qknxl";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/share/man/man8
    cp bashcards.8 $out/share/man/man8/
    cp bashcards $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Practice flashcards in bash";
    homepage = "https://github.com/rpearce/bashcards/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rpearce ];
    platforms = platforms.all;
  };
}
