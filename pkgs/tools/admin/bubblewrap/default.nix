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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "bubblewrap";
    rev = "v${version}";
    hash = "sha256-J+VFla3sWO+DfB2IxxrKzbiG+KWFJr9caf8sTHyWXY4=";
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
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
