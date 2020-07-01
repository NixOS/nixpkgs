{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "phraseapp-client";
  version = "1.11.0";

  goPackagePath = "github.com/phrase/phraseapp-client";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phraseapp-client";
    rev = version;
    sha256 = "0lfx0wv95hgczi74qnkw2cripwgvl53z2gi5i6nyflisy4r7vvkr";
  };

  postInstall = ''
    ln -s $out/bin/phraseapp-client $out/bin/phraseapp
  '';

  meta = with stdenv.lib; {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
