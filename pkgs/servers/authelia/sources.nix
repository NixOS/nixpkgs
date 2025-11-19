{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.14";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-CUtoyre1WLLzz0bo7L+JGFztSjx29ZciT5AleIFCPtk=";
  };
  vendorHash = "sha256-hPrXKq57K8ftLq1qLlUI8bt1/R1WCvYwUt0q8k/OOow=";
  pnpmDepsHash = "sha256-wXUkEngtxPoCF6akMr/NTkFk2OskWeytkoefcx9CFVE=";
}
