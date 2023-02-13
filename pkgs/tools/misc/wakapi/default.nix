{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "1bhd96la2ipwna9lic50pd5klcc3xj9yqd5rd1cgzznbm4ylpjqb";
  };

  vendorHash = "sha256-fkSXaP9hHCCyO8mFB5CKPExifuNjTvDnXupjCVllG9I";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://wakapi.dev/";
    changelog = "https://github.com/muety/wakapi/releases/tag/${version}";
    description = "A minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ t4ccer ];
  };
}
