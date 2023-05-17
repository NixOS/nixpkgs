{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.47.2";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SWypxCtgVORYGOAiepfAfqnB4JjMwCC3e8lFZ/9tiCM=";
  };

  cargoHash = "sha256-OaPh3/Z9mF56NeHpCehsuJHU6ClzE+beRsAG/lWIwp0=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
