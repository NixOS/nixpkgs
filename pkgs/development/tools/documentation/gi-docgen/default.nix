{ lib
, fetchurl
, meson
, ninja
, python3
, gnome
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gi-docgen";
  version = "2023.3";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/gi-docgen/${lib.versions.major version}/gi-docgen-${version}.tar.xz";
    hash = "sha256-TesfCXc/cGJZrGUgUNp7PuWYcbw/1c+3foEdt0mNyOc=";
  };

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
    packaging
    pygments
    toml # remove once python311 is the default
    typogrify
  ];

  doCheck = false; # no tests

  postFixup = ''
    # Do not propagate Python
    substituteInPlace $out/nix-support/propagated-build-inputs \
      --replace "${python3}" ""
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gi-docgen";
    };
  };

  meta = with lib; {
    description = "Documentation generator for GObject-based libraries";
    mainProgram = "gi-docgen";
    homepage = "https://gitlab.gnome.org/GNOME/gi-docgen";
    license = licenses.asl20; # OR GPL-3.0-or-later
    maintainers = teams.gnome.members;
  };
}
