{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "metabigor";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ADpnSsGZQbXaSGidPmxwkQOl+P8ZupqRaDUh7t+XoDw=";
  };

  vendorSha256 = "sha256-la7bgeimycltFB7l6vNBYdlBIv4kD+HX7f2mo+eZhXM=";

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = with lib; {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
