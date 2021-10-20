{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    sha256 = "sha256-VzK6WykC3UDlhhyu8LMRHgOMkdEssJuh1Aqp0rGx7F4=";
  };

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  vendorSha256 = "sha256-ZRUy6gsl4Q2Sdm8Bfo4ANPdwcNQi5LNV6SbynpwfnOc=";

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
