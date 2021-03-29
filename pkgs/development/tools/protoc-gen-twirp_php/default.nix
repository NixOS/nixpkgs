{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.6.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-WnvCdAJIMA4A+f7H61qcVbKNn23bNVOC15vMCEKc+CI=";
  };

  vendorSha256 = "sha256-LIMxrWXlK7+JIRmtukdXPqfw8H991FCAOuyEf7ZLSTs=";

  subPackages = [ "protoc-gen-twirp_php" ];

  preBuild = ''
    go generate ./...
  '';

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
