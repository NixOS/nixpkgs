{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "influxdb2-token-manipulator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "influxdb2-token-manipulator";
    rev = "v${version}";
    hash = "sha256-9glz+TdqvGJgSsbLm4J/fn7kzMC75z74/jxZrEZiooc=";
  };

  vendorHash = "sha256-zBZk7JbNILX18g9+2ukiESnFtnIVWhdN/J/MBhIITh8=";

  meta = with lib; {
    description = "Utility program to manipulate influxdb api tokens for declarative setups";
    homepage = "https://github.com/oddlama/influxdb2-token-manipulator";
    license = licenses.mit;
    maintainers = with maintainers; [oddlama];
    mainProgram = "influxdb2-token-manipulator";
  };
}
