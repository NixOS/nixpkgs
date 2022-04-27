{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tubular";
  version = "2022.2.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = version;
    sha256 = "sha256-nK+YxHFy88mEQAcPt2gGz5JwA3G99YQf5wPjsTqCavc=";
  };

  vendorSha256 = null;

  postInstall = ''
    rm -f $out/bin/example
  '';

  # check fails
  doCheck = false;

  meta = with lib; {
    description = "BSD socket API on steroids";
    homepage = "https://github.com/cloudflare/tubular";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbe ];
  };
}
