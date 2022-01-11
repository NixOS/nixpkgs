{ lib, buildGoModule, fetchFromGitHub, runCommand, gofumpt }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NkflJwFdVcFTjXkDr8qqAFUlKwGNPTso6hvu7Vikn2U=";
  };

  vendorSha256 = "sha256-RZPfdj+rimKGvRZKaXOirkd7ietri55rBofwa/l2z8s=";

  # editorconfig-checker-disable
  passthru.tests = {
    simple = runCommand "gofumpt-test" { } ''
      ${gofumpt}/bin/gofumpt > $out <<EOF
      package main
      import  "fmt" 

      func main (    ){
      fmt.  Println("Hello World!") 
      }
      EOF

      [ "$(cat $out)" = "$(cat ${./hello.go})" ]
    '';
  };
  # editorconfig-checker-enable

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
