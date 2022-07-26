{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "goresym";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XDy6qALE2xuOVQHuuvU/gOyTRZ/6CWpyjN3i7VmznoI=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-dnQ/tP4RS6WkACobfW7jTTJSHbLrdlZDy1fmO65743Q=";

  doCheck = true;

  meta = with lib; {
    description = "Go symbol recovery tool";
    homepage = "https://github.com/mandiant/GoReSym";
    license = licenses.mit;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
