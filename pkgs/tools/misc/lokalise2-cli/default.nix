{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "15lwy2rrb5d5r0asa51bgjr42pcknk6znx6qirw9s924i8dbzp6s";
  };

  vendorSha256 = "06y1v0v1kkbd5vxa8h0qvasm9ibwwhz0v4x03k3nb5xlwn0x9jx8";

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = with stdenv.lib; {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timstott ];
    platforms = platforms.unix;
  };
}
