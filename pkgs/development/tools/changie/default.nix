{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.9.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-3i+GInsxGeHXdFYfI664sOshHFsEIVXgXolzPhc9eoM=";
  };

  vendorSha256 = "sha256-/tYhoHk4+gbdfeBNqcBSM0y4V3tVH67Xta3+e+Sctsg=";

  meta = with lib; {
    homepage = "https://changie.dev";
    description = "Automated changelog tool for preparing releases with lots of customization options";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

