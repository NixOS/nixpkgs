{ lib, fetchFromGitHub, perl, perlPackages }:

perlPackages.buildPerlPackage rec {
  pname = "cope";
  version = "unstable-2024-03-27";

  src = fetchFromGitHub {
    owner = "deftdawg";
    repo = pname;
    rev = "ad0c1ebec5684f5ec3e8becf348414292c489175";
    sha256 = "sha256-LMAir7tUkjHtKz+KME/Raa9QHGN1g0bzr56fNxfURQY=";
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
    maintainers = with maintainers; [ deftdawg ];
  };
}
