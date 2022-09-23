{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "0asjmqfzdrpfx2hd5hkac1swp52qknyqavsm59j8xr4c1ixhc6n9";
  };

  vendorSha256 = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";

  meta = with lib; {
    description = "A fork of esbuild maintained by netlify";
    homepage = "https://github.com/netlify/esbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ roberth ];
  };
}
