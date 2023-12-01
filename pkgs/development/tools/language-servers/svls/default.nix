{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-ylTiyqFVdT95a5DP4YYtoAIGThA+TacAE8ft0mcuolI=";
  };

  cargoHash = "sha256-+h2lxIbfHCGKCWX8ly9NXskMkeRGIpujkX3Zep1WhrE=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
