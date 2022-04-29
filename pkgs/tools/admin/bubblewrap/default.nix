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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "bubblewrap";
    rev = "v${version}";
    sha256 = "sha256-YmK/Tq9/JTJr5gLNKEH5t6TvvXlNSTDz5Ui7d3ewv2s=";
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
