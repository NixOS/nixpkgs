{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "0103py4v4v7xqv85yiczhd9w9h1aa54svhhdibvbl6x4b35y2mk5";
  };

  cargoSha256 = "1k0d7yadicfzfc2m1aqs4c4a2k3srb54fpwarc3kwn26v3vfjai1";

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/raw/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
