{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dfrs";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "anthraxx";
    repo = pname;
    rev = version;
    sha256 = "01h00328kbw83q11yrsvcly69p0hql3kw49b4jx6gwkrdm8c2amk";
  };

  cargoSha256 = "1dgmn4g35yc7hwnxznkrpwnikn329nc0z8y7bxlcd308k1v83919";

  meta = with lib; {
    description = "Display file system space usage using graphs and colors";
    homepage = "https://github.com/anthraxx/dfrs";
    license = licenses.mit;
    maintainers = with maintainers; [ wamserma ];
    mainProgram = "dfrs";
  };
}
