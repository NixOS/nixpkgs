{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.16.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-WK5TAI+dYmBLNp1A0p9DbWF7ZEw3dqr+Cuwy7LzrdBM=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-7IpMgsATQ1SMuBOF9agHIN2Lx6OKxRr0Zk5SRFxHiQ4=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ]
    ++ lib.optionals stdenv.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
