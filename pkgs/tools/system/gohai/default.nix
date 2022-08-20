{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gohai";
  version = "unstable-2022-04-12";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "gohai";
    rev = "c614f513e87f04d3d19b2d4ae853cc5703f3a9bc";
    sha256 = "sha256-vdzGGTg9SHYS0OQUn3VvrQGpKxzqxBRXDKOm0c7FvYY=";
  };

  vendorSha256 = "sha256-aN1fwGbBm45e6qdRu+4wnv2ZI7SOsIPONB4vF9o2vlI=";

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    description = "System information collector";
    homepage = "https://github.com/DataDog/gohai";
    license = licenses.mit;
    maintainers = with maintainers; [ tazjin ];
    platforms = platforms.unix;

    longDescription = ''
      Gohai is a tool which collects an inventory of system
      information. It is used by the Datadog agent to provide detailed
      system metrics.
    '';
  };
}
