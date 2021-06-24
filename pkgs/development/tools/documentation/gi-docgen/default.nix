{ lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gi-docgen";
  version = "2021.2";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ebassi";
    repo = pname;
    rev = version;
    sha256 = "17swx4s60anfyyb6dcsl8fq3s0j9cy54qcw0ciq4qj59d4039w5h";
  };

  patches = [
    # Add pkg-config file so that Meson projects can find this.
    # https://gitlab.gnome.org/ebassi/gi-docgen/merge_requests/26
    (fetchpatch {
      url = "https://gitlab.gnome.org/jtojnar/gi-docgen/commit/d65ed2e4827c4129d26e3c1df9a48054b4e72c50.patch";
      sha256 = "BEefcHiAd/HTW5zo39J2WtfQjGXUkNFB6MDJj8/Ge80=";
    })

    # Name generated devhelp files correctly.
    # https://gitlab.gnome.org/ebassi/gi-docgen/merge_requests/27
    (fetchpatch {
      url = "https://gitlab.gnome.org/ebassi/gi-docgen/commit/7c4de72f55cbce5670c3a6a1451548e97e5f07f7.patch";
      sha256 = "ov/PvrZzKmCzw7nHJkbeLCnhtUVw1UbZQjFrWT3AtVg=";
    })

    # Fix broken link in Devhelp TOC.
    # https://gitlab.gnome.org/ebassi/gi-docgen/merge_requests/28
    (fetchpatch {
      url = "https://gitlab.gnome.org/ebassi/gi-docgen/commit/56f0e6f8b4bb9c92d635df60aa5d68f55b036711.patch";
      sha256 = "5gFGiO9jPpkyZBL4qtWEotE5jY3sCGFGUGN/Fb6jZ+0=";
    })

    # Devhelp does not like subsections without links.
    # https://gitlab.gnome.org/GNOME/devhelp/-/issues/28
    (fetchpatch {
      # Only visual but needed for the other two to apply.
      # https://gitlab.gnome.org/ebassi/gi-docgen/merge_requests/28
      url = "https://gitlab.gnome.org/ebassi/gi-docgen/commit/7f67fad5107b73489cb7bffca49177d9ad78e422.patch";
      sha256 = "OKbC690nJsl1ckm/y9eeKDYX6AEClsNvIFy7DK+JYEc=";
    })
    # Add links to index.
    (fetchpatch {
      url = "https://gitlab.gnome.org/ebassi/gi-docgen/commit/f891cc5fd481bc4180eec144d14f32c15c91833b.patch";
      sha256 = "Fcnvdgxei+2ulGoWoCZ8WFrNy01tlNXMkHru3ArGHVQ=";
    })
    # Use different link for each symbol type name.
    # https://gitlab.gnome.org/ebassi/gi-docgen/merge_requests/29
    (fetchpatch {
      url = "https://gitlab.gnome.org/jtojnar/gi-docgen/commit/08dcc31f62be1a5af9bd9f8f702f321f4b5cffde.patch";
      sha256 = "vAT8s7zQ9zCoZWK+6PsxcD5/48ZAfIOl4RSNljRCGWQ=";
    })
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
    homepage = "https://gitlab.gnome.org/ebassi/gi-docgen";
    license = licenses.asl20; # OR GPL-3.0-or-later
    maintainers = teams.gnome.members;
  };
}
