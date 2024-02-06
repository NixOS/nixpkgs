{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rtrtr";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-meZ24qIug2Zkw6PcB697CRuujVRIUuSrgugwnBM9gj8=";
  };

  cargoSha256 = "sha256-9wUfgkiQn2Du5UNBOy/+NZkFwqHAQoyqj8xQhIljKFY=";

  buildInputs = lib.optional stdenv.isDarwin Security;
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
