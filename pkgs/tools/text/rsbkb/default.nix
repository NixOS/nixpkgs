{ lib
, fetchFromGitHub
, rustPlatform
, enableAppletSymlinks ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rsbkb";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "trou";
    repo = "rsbkb";
    rev = "release-${version}";
    hash = "sha256-SGV7ovaOVnOFlCSyxKrd4Tg8Ak71BzvLgEvCneHhx0w=";
  };

  cargoHash = "sha256-UC9i1rPdQ4YLQoMQYXyL0j6EUhMwyKuD+vk4z5XLLAk=";

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
