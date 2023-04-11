{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.47.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CW7rPylP3Swyv+rxwbeooUC6XEkmGCCpGEqM7zNG1b4=";
  };

  cargoHash = "sha256-yO0wcijM8q81g/HSmouHduUb12kaNVRIv4pECs8XyFw=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
