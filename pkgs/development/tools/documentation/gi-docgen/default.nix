{ lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gi-docgen";
  version = "2021.8";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "Y1IdCH6bytxbKIj48IAw/3XUQhoqwPshvdj/d1hRS3o=";
  };

  patches = [
    # Fix building docs of some packages (e.g. gnome-builder)
    # https://gitlab.gnome.org/GNOME/gi-docgen/-/issues/111
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gi-docgen/-/commit/72f3c5dbe27aabb5f7a376afda23f3dfc3c2e212.patch";
      sha256 = "iVXc3idmcjmFVZQdE2QX2V53YZ79lqxZid9nWdxAZ/Q=";
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
