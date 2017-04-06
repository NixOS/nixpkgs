{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "phraseapp-client-${version}";
  version = "1.4.3";

  goPackagePath = "github.com/phrase/phraseapp-client";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phraseapp-client";
    rev = version;
    sha256 = "1nfab7y75vl0vg9vy8gc46h7wikk94nky1n415im1xbpsnqg77wz";
  };

  meta = with stdenv.lib; {
    homepage = http://docs.phraseapp.com;
    description = "PhraseApp API v2 Command Line Client";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
