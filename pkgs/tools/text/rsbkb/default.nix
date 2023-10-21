{ lib
, fetchFromGitHub
, rustPlatform
, enableAppletSymlinks ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rsbkb";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "trou";
    repo = "rsbkb";
    rev = "release-${version}";
    hash = "sha256-+plf7BoYpEFPRsGKNrvLF8TAU3Z7nyx6Td6uRBoNGiE=";
  };

  cargoHash = "sha256-HyosR/5tZCRU2CNnnGITEuESW30Zq3s33UFNcLmEWIA=";

  # Setup symlinks for all the utilities,
  # busybox style
  postInstall = lib.optionalString enableAppletSymlinks ''
    cd $out/bin || exit 1
    path="$(realpath --canonicalize-missing ./rsbkb)"
    for i in $(./rsbkb list) ; do ln -s $path $i ; done
  '';

  meta = with lib; {
    description = "Command line tools to encode/decode things";
    homepage = "https://github.com/trou/rsbkb";
    changelog = "https://github.com/trou/rsbkb/releases/tag/release-${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
