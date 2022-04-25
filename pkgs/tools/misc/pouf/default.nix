{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pouf";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    sha256 = "0q7kj6x61xci8piax6vg3bsm9di11li7pm84vj13iwahdydhs1hn";
  };

  cargoSha256 = "128fgdp74lyv5k054cdjxzwmyb5cyy0jq0a9l4bsc34122mznnq7";

  meta = with lib; {
    description = "A cli program for produce fake datas.";
    homepage = "https://github.com/mothsart/pouf";
    changelog = "https://github.com/mothsart/pouf/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = with licenses; [ mit ];
  };
}
