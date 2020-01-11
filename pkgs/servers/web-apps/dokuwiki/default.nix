{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dokuwiki";
  version = "2018-04-22b";

  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = "${pname}";
    rev = "release_stable_${version}";
    sha256 = "1na5pn4j4mi2la80ywzg1krwqdxz57mjkw0id6ga9rws809gkdjp";
  };

  installPhase = ''
    mkdir -p $out/share/dokuwiki
    cp -r * $out/share/dokuwiki
  '';

  meta = with stdenv.lib; {
    description = "Simple to use and highly versatile Open Source wiki software that doesn't require a database";
    license = licenses.gpl2;
    homepage = "https://www.dokuwiki.org";
    platforms = platforms.all;
    maintainers = [ maintainers."1000101" ];
  };
}
