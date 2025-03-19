{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.1";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-Q/NGjJphuZ7MMnOSTAukzEg4iAQWc/VDFWs0jj4e0dY=";
  };
  vendorHash = "sha256-FE4YABsWKhifVjdzJSnjWPesjuSe/hWDa6oTg8MZjo8=";
  pnpmDepsHash = "sha256-TJ/Uz7Q+mXfvZ/Zu12Pv1O8LKTzEPJ+Pa+3vrKghPks=";
}
