{ lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gi-docgen";
  version = "2022.1";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "35pL/2TQRVgPfAcfOGCLlSP1LIh4r95mFC+UoXQEEHo=";
  };

  patches = [
    # Fix gnome-builder build
    # https://gitlab.gnome.org/GNOME/gi-docgen/-/merge_requests/161
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gi-docgen/-/commit/0524047ada3e6a5572c43dd36201ebe589d08095.patch";
      sha256 = "1P+i7v1sMULOd0w8K363Mssj+tBJ2wiSmE7DlztvCbw=";
    })
  ];

  depsBuildBuild = [
    python3
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  pythonPath = with python3.pkgs; [
    jinja2
    markdown
    markupsafe
    pygments
    toml
    typogrify
  ];

  doCheck = false; # no tests

  postFixup = ''
    # Do not propagate Python
    substituteInPlace $out/nix-support/propagated-build-inputs \
      --replace "${python3}" ""
  '';

  meta = with lib; {
    description = "Documentation generator for GObject-based libraries";
    homepage = "https://gitlab.gnome.org/GNOME/gi-docgen";
    license = licenses.asl20; # OR GPL-3.0-or-later
    maintainers = teams.gnome.members;
  };
}
