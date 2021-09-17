{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "1i9h96b0b69ib72b2ayp8mhgvkm21jbh8mf7wb1fp2gdzbxcgrhg";
  };

  vendorSha256 = "1fs1jqxz36i25vyb0mznkjglz8wwq9a8884052cjpacvsgd3glkf";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
  };
}
