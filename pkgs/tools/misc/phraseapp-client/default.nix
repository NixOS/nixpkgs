{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "phraseapp-client-${version}";
  version = "1.6.0";

  goPackagePath = "github.com/phrase/phraseapp-client";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phraseapp-client";
    rev = version;
    sha256 = "0rgwl0rgkci045hg36s0q8jwkni1hzapqpi0mc0gk3rl7nagw622";
  };

  meta = with stdenv.lib; {
    homepage = http://docs.phraseapp.com;
    description = "PhraseApp API v2 Command Line Client";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
