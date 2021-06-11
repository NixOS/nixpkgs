{ lib, rustPlatform, fetchFromGitHub
, fetchpatch
, fuse
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "catfs";
  version = "unstable-2020-03-21";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = pname;
    rev = "daa2b85798fa8ca38306242d51cbc39ed122e271";
    sha256 = "0zca0c4n2p9s5kn8c9f9lyxdf3df88a63nmhprpgflj86bh8wgf5";
  };

  cargoSha256 = "1agcwq409s40kyij487wjrp8mj7942r9l2nqwks4xqlfb0bvaimf";

  cargoPatches = [
    # update cargo lock
    (fetchpatch {
      url = "https://github.com/kahing/catfs/commit/f838c1cf862cec3f1d862492e5be82b6dbe16ac5.patch";
      sha256 = "1r1p0vbr3j9xyj9r1ahipg4acii3m4ni4m9mp3avbi1rfgzhblhw";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse ];

  # require fuse module to be active to run tests
  # instead, run command
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/catfs --help > /dev/null
  '';

  meta = with lib; {
    description = "Caching filesystem written in Rust";
    homepage = "https://github.com/kahing/catfs";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jonringer ];
  };
}
