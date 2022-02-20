{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jless";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "PaulJuliusMartinez";
    repo = "jless";
    rev = "v${version}";
    sha256 = "sha256-IK+EllkctdhIYuzj7eLjadxKoutICPeSXAjLMFiRjmo=";
  };

  cargoSha256 = "sha256-CAyKWwtMq5UOODVRrpVHrhlep2wqG434dMGeYV2FSZY=";

  meta = with lib; {
    description = "A command-line pager for JSON data";
    homepage = "https://github.com/PaulJuliusMartinez/jless";
    license = licenses.mit;
    maintainers = with maintainers; [ jfchevrette zowoq ];
  };
}
