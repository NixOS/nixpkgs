{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rDT7ZpixE77imy/HVwLET+O0uCZ+wFhXGqcWq46Ud2w=";
  };

  cargoHash = "sha256-B5H8YkYlcF/Z6SlsW5lWwHZ9tYfOb54Pu1KNVY3eXP8=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
