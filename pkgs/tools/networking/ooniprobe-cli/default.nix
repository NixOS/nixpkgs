{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-lIRU6TM76/uX2LA4hdWbF4fbbcfGMUzmGz4e1PTyH3c=";
  };

  vendorSha256 = "h06WoKykuVzNgco74YbpSP+1nu/bOEf2mT4rUEX8MxU=";

  subPackages = [ "cmd/ooniprobe" ];

  meta = with lib; {
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
