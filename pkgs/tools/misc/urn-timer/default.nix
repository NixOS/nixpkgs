{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, unstableGitUpdater
, xxd
, pkg-config
, imagemagick
, wrapGAppsHook
, gtk3
, jansson
}:

stdenv.mkDerivation {
  pname = "urn-timer";
  version = "unstable-2017-08-20";

  src = fetchFromGitHub {
    owner = "3snowp7im";
    repo = "urn";
    rev = "246a7a642fa7a673166c1bd281585d0fc22e75b2";
    sha256 = "0bniwf3nhsqapsss9m9y9ylh38v6v7q45999wa1qcsddpa72k0i0";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/3snowp7im/urn/pull/50
    (fetchpatch {
      name = "stop-hardcoding-prefix";
      url = "https://github.com/3snowp7im/urn/commit/6054ee62dcd6095e31e8fb2a229155dbbcb39f68.patch";
      sha256 = "1xdkylbqlqjwqx4pb9v1snf81ag7b6q8vybirz3ibsv6iy79v9pk";
    })
    # https://github.com/3snowp7im/urn/pull/53
    (fetchpatch {
      name = "create-installation-directories";
      url = "https://github.com/3snowp7im/urn/commit/fb032851b9c5bebb5066d306f5366f0be34f0797.patch";
      sha256 = "0jjhcz4n8bm3hl56rvjzkvxr6imc05qlyavzjrlafa19hf036g4a";
    })
  ];

  postPatch = ''substituteInPlace GNUmakefile --replace 'rsync -a --exclude=".*"' 'cp -r' '';

  nativeBuildInputs = [
    xxd
    pkg-config
    imagemagick
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    jansson
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/3snowp7im/urn.git";
  };

  meta = with lib; {
    homepage = "https://github.com/3snowp7im/urn";
    description = "Split tracker / timer for speedrunning with GTK+ frontend";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
  };
}
