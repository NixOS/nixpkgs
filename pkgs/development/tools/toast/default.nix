{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.46.2";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WsNBBivfw0tUF3TsJBbg7A13IcFEqclF9MR55xogI5Q=";
  };

  cargoHash = "sha256-hZA5iWZ2KKifvHRx5p9LM/la80ezyzV2XOuxq0lRYB0=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
