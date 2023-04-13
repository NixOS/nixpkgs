{ lib
, stdenv
, fetchFromGitHub
, docbook_xsl
, libxslt
, meson
, ninja
, pkg-config
, bash-completion
, libcap
, libselinux
}:

stdenv.mkDerivation rec {
  pname = "bubblewrap";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "bubblewrap";
    rev = "v${version}";
    hash = "sha256-UiZfp1bX/Eul5x31oBln5P9KMT2oFwawQqDs9udZUxY=";
  };

  postPatch = ''
    substituteInPlace tests/libtest.sh \
      --replace "/var/tmp" "$TMPDIR"
  '';

  nativeBuildInputs = [
    docbook_xsl
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    bash-completion
    libcap
    libselinux
  ];

  # incompatible with Nix sandbox
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/containers/bubblewrap/releases/tag/${src.rev}";
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
    mainProgram = "bwrap";
  };
}
