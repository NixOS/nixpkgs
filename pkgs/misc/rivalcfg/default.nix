{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "rivalcfg";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "rivalcfg";
    rev = "v${version}";
    sha256 = "sha256-fCl+XY+R+QF7jWLkqii4v0sbXr7xoX3A3upm+XoBAms=";
  };

  propagatedBuildInputs = with python3Packages; [ hidapi setuptools ];

  checkInputs = [ python3Packages.pytest ];
  checkPhase = "pytest";

  # tests are broken
  doCheck = false;

  postInstall = ''
    set -x
    mkdir -p $out/lib/udev/rules.d
    tmpl_udev="$out/lib/udev/rules.d/99-rivalcfg.rules"
    tmpudev="''${tmpl_udev}.in"
    finaludev="$tmpl_udev"
    "$out/bin/rivalcfg" --print-udev > "$tmpudev"
    substitute "$tmpudev" "$out/lib/udev/rules.d/99-rivalcfg.rules" \
      --replace MODE=\"0666\" "MODE=\"0664\", GROUP=\"input\""
    rm "$tmpudev"
  '';

  meta = with lib; {
    description = "Utility program that allows you to configure SteelSeries Rival gaming mice";
    homepage = "https://github.com/flozz/rivalcfg";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ornxka ];
    mainProgram = "rivalcfg";
  };
}
