{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D/wJAmlc6OUuD8kSfGevG+UoPKy58X0lObL7mjiBG+c=";
  };

  cargoHash = "sha256-PFR6jMAvEybT/XOfLrv21F8ZxSX0BZDiEFtgQL5fL18=";

  cargoPatches = [
    # update the version to 0.3.3
    (fetchpatch {
      name = "chore-prepare-release.patch";
      url = "https://github.com/JakWai01/lurk/commit/cb4355674159255ac4186283a93de294de057d1b.patch";
      hash = "sha256-N+/8AGEToEqhkQ6BYGQP279foZbt6DzUBmAUaHm9hW4=";
    })
  ];

  patches = [
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/JakWai01/lurk/commit/87eb4aa8bf9a551b24cec2146699cb2c22d62019.patch";
      hash = "sha256-m44m1338VODX+HGEVMLozKfVvXsQxvLIpo28VBK//vM=";
    })
  ];

  meta = with lib; {
    description = "A simple and pretty alternative to strace";
    homepage = "https://github.com/jakwai01/lurk";
    changelog = "https://github.com/jakwai01/lurk/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
