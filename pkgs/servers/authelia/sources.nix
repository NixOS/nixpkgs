{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.0";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-c94TLYGCFjvxhrOP3EHHRcmqUSXVXXPwjRiDjSaeLuw=";
  };
  vendorHash = "sha256-FE4YABsWKhifVjdzJSnjWPesjuSe/hWDa6oTg8MZjo8=";
  pnpmDepsHash = "sha256-4NWPMGRlOoZgITIG1dmUd82xes4ze0uim2pQHGfsC90=";
}
