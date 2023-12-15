{ lib, fetchFromGitHub, perl, perlPackages }:

perlPackages.buildPerlPackage rec {
  pname = "cope";
  version = "unstable-2023-08-11";

  src = fetchFromGitHub {
    owner = "deftdawg";
    repo = pname;
    rev = "b6f3d56dbe49c02c98eaadc763fd6cb35c01933b";
    sha256 = "sha256-Slno/ke1XaHoIExbFwS3Rs/x1yno6E7rwQeJHpvFahM=";
  };

  buildInputs = with perlPackages; [ EnvPath FileShareDir IOPty IOStty ListMoreUtils RegexpCommon RegexpIPv6 ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/lib/perl5/site_perl/${perl.version}/auto/share/dist/Cope/* $out/bin/
    rm -r $out/lib/perl5/site_perl/${perl.version}/auto
  '';

  meta = with lib; {
    description = "A colourful wrapper for terminal programs";
    homepage = "https://github.com/deftdawg/cope";
    license = with licenses; [ artistic1 gpl1Plus ];
    maintainers = with maintainers; [ ];
  };
}
