{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
<<<<<<< HEAD
  version = "3.19.0";
=======
  version = "3.16.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
<<<<<<< HEAD
    hash = "sha256-EGnamJBotPDatsWG+XLI/QhF2464aphkB9oS631oj+c=";
    rev = "v${version}";
  };

  vendorHash = "sha256-gjRUt8/LECFSU2DG4ALi7a3DxKAGFoW98eBgeE5i2+s=";

  nativeBuildInputs = [ pkg-config gobject-introspection ];

  buildInputs = [ vips ]
=======
    sha256 = "sha256-l5THMK6YUfScTeralhEl5SDBDoeV3Olt1xzdzeJ8BEQ=";
    rev = "v${version}";
  };

  vendorHash = "sha256-EtNFSAx8YcRhzgV3IdrZaCM6fOd284iuTperCFECsL8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optionals stdenv.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
<<<<<<< HEAD
    changelog = "https://github.com/imgproxy/imgproxy/blob/${src.rev}/CHANGELOG.md";
=======
    changelog = "https://github.com/imgproxy/imgproxy/blob/master/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
