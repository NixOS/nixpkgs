{ lib, fetchFromGitHub, fetchurl, python3Packages, installShellFiles, gitUpdater }:

python3Packages.buildPythonApplication rec {
  pname = "unicode";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "sha256-FHAlZ5HID/FE9+YR7Dmc3Uh7E16QKORoD8g9jgTeQdY=";
  };

  ucdtxt = fetchurl {
    url = "https://www.unicode.org/Public/14.0.0/ucd/UnicodeData.txt";
    sha256 = "sha256-NgGOaGV/3LNIX2NmMP/oyFMuAcl3cD0oA/W4nWxf6vs=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace "/usr/share/unicode/UnicodeData.txt" "$ucdtxt"
  '';

  postInstall = ''
    installManPage paracode.1 unicode.1
  '';

  passthru.updateScript = gitUpdater {
    inherit version;
    pname = "unicode-paracode";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Display unicode character properties";
    homepage = "https://github.com/garabik/unicode";
    license = licenses.gpl3;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
  };
}
