{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.47.5";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kAXzBJMAxHjZSK6lbpF+/27n9CGvq7x6Ay2TaFYgQSU=";
  };

  cargoHash = "sha256-681ZFS8dtn815VYdFwPEJXnuMGTycSuRPDxmj1kN3rs=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
