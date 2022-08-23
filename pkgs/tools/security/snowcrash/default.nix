{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "snowcrash";
  version = "unstable-2021-04-29";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "SNOWCRASH";
    rev = "514cceea1ca82f44e0c8a8744280f3a16abb6745";
    sha256 = "16p1nfi9zdlcffjyrk1phrippjqrdzf3cpc51dgdy3bfr7pds2ld";
  };

  vendorSha256 = "sha256-YryQKLHwUDhR/Z7eWfCdL86Z83GrqBTvdGGj+dGKvjI";

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
