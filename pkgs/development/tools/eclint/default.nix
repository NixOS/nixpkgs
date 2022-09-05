{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule
rec {
  pname = "eclint";
  version = "0.3.4";

  src = fetchFromGitLab {
    owner = "greut";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-inO41C/Ompyfy4CHPK4ksNU19KIcGyPgF/ptZC0GWXg=";
  };

  vendorSha256 = "sha256-imVQnPoKOjed9XlikLWvudmlJklRrLFHKtNZoAmznZg=";

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
