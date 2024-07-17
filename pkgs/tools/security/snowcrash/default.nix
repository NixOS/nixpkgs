{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "snowcrash";
  version = "unstable-2022-08-15";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "SNOWCRASH";
    rev = "32e62f9ff7d3dda9fac8acfc56176f1f2a70d066";
    hash = "sha256-mURF/VUqygd5bLJdmbwnZq003IXJKn+k8HtS+CxoQJQ=";
  };

  vendorHash = "sha256-WTDE+MYL8CjeNvGHRNiMgBFrydDJWIcG8TYvbQTH/6o=";

  subPackages = [ "." ];

  postFixup = lib.optionals (!stdenv.isDarwin) ''
    mv $out/bin/SNOWCRASH $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Polyglot payload generator";
    homepage = "https://github.com/redcode-labs/SNOWCRASH";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ] ++ teams.redcodelabs.members;
    mainProgram = "SNOWCRASH";
  };
}
