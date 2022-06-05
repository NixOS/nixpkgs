{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "phraseapp-client";
  version = "1.17.1";

  goPackagePath = "github.com/phrase/phraseapp-client";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phraseapp-client";
    rev = version;
    sha256 = "0j8fygp9bw68p1736hq7n7qv86rghchxbdm1xibvk5jpgph1nzl7";
  };

  postInstall = ''
    ln -s $out/bin/phraseapp-client $out/bin/phraseapp
  '';

  meta = with lib; {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
