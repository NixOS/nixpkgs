{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "apcupsd-exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "apcupsd_exporter";
    rev = "v${version}";
    sha256 = "0gjj23qdjs7rqimq95rbfw43m4l6g73j840svxjlmpd1vzzz2v2q";
  };

  vendorSha256 = "09x8y8pmgfn897hvnk122ry460y12b8a7y5fafri5wn9vxab9r82";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) apcupsd; };

  meta = with stdenv.lib; {
    description = "Provides a Prometheus exporter for the apcupsd Network Information Server (NIS)";
    homepage = "https://github.com/mdlayher/apcupsd_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers."1000101" mdlayher ];
    platforms = platforms.all;
  };
}
