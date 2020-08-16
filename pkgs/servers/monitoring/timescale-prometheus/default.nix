{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "timescale-prometheus";
  version = "0.1.0-beta.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "${version}";
    sha256 = "1q6xky4h9x4j2f0f6ajxwlnqq1pgd2n0z1ldrcifyamd90qkwcm5";
  };

  vendorSha256 = "sha256:1vp30y59w8mksqxy9ic37vj1jw4lbq24ahhb08a72rysylw94r57";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/timescale-prometheus";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers."0x4A6F" ];
  };
}
