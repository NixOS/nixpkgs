{ buildGoModule, lib, fetchurl }:

buildGoModule rec {
  pname = "filegive";
  version = "unstable-2022-05-29";
  rev = "5b28e7087a";

  src = fetchurl {
    url = "https://viric.name/cgi-bin/filegive/tarball/${rev}/filegive-${rev}.tar.gz";
    hash = "sha256-A69oys59GEysZvQLaYsfoX/X2ENMMH2BGfJqXohQjpc=";
  };

  vendorHash = "sha256-l7FRl58NWGBynMlGu1SCxeVBEzTdxREvUWzmJDiliZM=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://viric.name/cgi-bin/filegive";
    description = "Easy p2p file sending program";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ viric ];
  };
}
