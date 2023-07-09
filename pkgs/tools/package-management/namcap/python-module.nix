{ fetchFromGitLab
, fetchzip
, coreutils
, pacman
, python
, runtimeShell
, zstd
}:

let
  licenses = fetchzip {
    url = "https://geo.mirror.pkgbuild.com/core/os/x86_64/licenses-20220125-2-any.pkg.tar.zst";
    hash = "sha256-8HEn+pFpxPUi6hyM2wvWcdImIK1Cgjn1I8PYiguYR5s=";
    nativeBuildInputs = [ zstd ];
    stripRoot = false;
  };
in

python.pkgs.buildPythonPackage rec {
  pname = "namcap";
  version = "3.4.2";
  format = "pyproject";

  src = fetchFromGitLab {
    domain = "gitlab.archlinux.org";
    owner = "pacman";
    repo = "namcap";
    rev = version;
    hash = "sha256-SxOIUkzJdvvnq15FEMfz6WIXl501sq56t3cB7Jxft5Q=";
  };

  patches = [
    ./make-etc-pacman-conf-optional.patch
  ];

  postPatch = ''
    substituteInPlace scripts/parsepkgbuild \
      --replace "/bin/bash" "${runtimeShell}" \
      --replace "/usr/bin/env" "${coreutils}/bin/env" \
      --replace "/etc/makepkg.conf" "${pacman}/etc/makepkg.conf" \
      --replace "''${PARSE_PKGBUILD_PATH:-/usr/share/namcap}" "$out/share/namcap"
    substituteInPlace Namcap/package.py \
      --replace '"parsepkgbuild"' "\"$out/bin/parsepkgbuild\""
    substituteInPlace Namcap/tags.py \
      --replace "/usr/share/namcap" "$out/share/namcap"
    substituteInPlace Namcap/rules/licensepkg.py \
      --replace "/usr/share/licenses" "${licenses}/usr/share/licenses"
  '';

  nativeBuildInputs = with python.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python.pkgs; [
    pyalpm
    pyelftools
  ];

  pythonImportsCheck = [ "Namcap" ];

  postInstall = ''
    USR=$out/${python.sitePackages}/usr
    mv $USR/* $out
    rmdir $USR
  '';

  passthru = {
    inherit licenses;
  };
}
