{ lib
, fetchFromGitHub
, rustPlatform
, enableAppletSymlinks ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rsbkb";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "trou";
    repo = "rsbkb";
    rev = "release-${version}";
    hash = "sha256-Y6YTjEbefNUPcl6rNYWVZLGZYTUPr5pvfLabS+zDWqA=";
  };

  cargoHash = "sha256-RMX+ZdPaqtqRJvhHFJJrPZnBGwQwZSCXNg1oNo+v2+8=";

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
