{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "butler";
  version = "15.21.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vciSmXR3wI3KcnC+Uz36AgI/WUfztA05MJv1InuOjJM=";
  };

  proxyVendor = true;

  vendorSha256 = "sha256-EIl0ZFDKbZopUR22hp5a2vRUu0O1h1O953NrtoNa2x8=";

  doCheck = false;

  meta = with lib; {
    description = "Command-line itch.io helper";
    homepage = "https://github.com/itchio/butler";
    license = licenses.mit;
    maintainers = with maintainers; [ martfont ];
  };
}
