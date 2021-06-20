{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.16.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-25oOGkTc19PHlU0Va7IPKrvGK9pDrGqKZa6qNFMVphQ=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-y8cXe4+jTLnM7K+na2VHGXkPgZjFYdgtDd14D8KiCas=";

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
