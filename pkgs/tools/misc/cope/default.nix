{ lib, fetchFromGitHub, perl, perlPackages }:

perlPackages.buildPerlPackage rec {
  pname = "cope";
  version = "unstable-2015-01-29";

  src = fetchFromGitHub {
    owner = "lotrfan";
    repo = pname;
    rev = "0dc82a939a9498ff80caf472841c279dfe03efae";
    sha256 = "sha256-Tkv26M6YnaUB0nudjKGG482fvUkCobPk0VF1manBCoY=";
  };

  buildInputs = with perlPackages; [ EnvPath FileShareDir IOPty IOStty ListMoreUtils RegexpCommon RegexpIPv6 ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/lib/perl5/site_perl/${perl.version}/auto/share/dist/Cope/* $out/bin/
    rm -r $out/lib/perl5/site_perl/${perl.version}/auto
  '';

  meta = with lib; {
    description = "A colourful wrapper for terminal programs";
    homepage = "https://github.com/lotrfan/cope";
    license = with licenses; [ artistic1 gpl1Plus ];
    maintainers = with maintainers; [ ];
  };
}
