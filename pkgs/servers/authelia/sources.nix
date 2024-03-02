{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.37.5";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-xsdBnyPHFIimhp2rcudWqvVR36WN4vBXbxRmvgqMcDw=";
  };
  vendorHash = "sha256-mzGE/T/2TT4+7uc2axTqG3aeLMnt1r9Ya7Zj2jIkw/w=";
  npmDepsHash = "sha256-MGs6UAxT5QZd8S3AO75mxuCb6U0UdRkGEjenOVj+Oqs=";
}
