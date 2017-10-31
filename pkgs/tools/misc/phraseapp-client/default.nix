{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "phraseapp-client-${version}";
  version = "1.4.5";

  goPackagePath = "github.com/phrase/phraseapp-client";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phraseapp-client";
    rev = version;
    sha256 = "0zky7jcs7h6zmvkb0na4la6h7g63jlrziifqk831fd1gspdzgajp";
  };

  meta = with stdenv.lib; {
    homepage = http://docs.phraseapp.com;
    description = "PhraseApp API v2 Command Line Client";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
