{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rtrtr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P9bofTmDpnNCVQAGeq9J2XqfNeula8nL1KoBIHMZNWg=";
  };

  cargoHash = "sha256-ToJLE4nqgTqg5D4Qh2zi+wjmcdwDo0aupoDwKJCTwnM=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;
  nativeBuildInputs = [ pkg-config ];

  buildNoDefaultFeatures = true;

  meta = with lib; {
    description = "RPKI data proxy";
    longDescription = ''
      TRTR is an RPKI data proxy, designed to collect Validated ROA Payloads
      from one or more sources in multiple formats and dispatch it onwards. It
      provides the means to implement multiple distribution architectures for RPKI
      such as centralised RPKI validators that dispatch data to local caching RTR
      servers. RTRTR can read RPKI data from multiple RPKI Relying Party packages via
      RTR and JSON and, in turn, provide an RTR service for routers to connect to.
    '';
    homepage = "https://github.com/NLnetLabs/rtrtr";
    changelog = "https://github.com/NLnetLabs/rtrtr/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ steamwalker ];
    mainProgram = "rtrtr";
  };
}
