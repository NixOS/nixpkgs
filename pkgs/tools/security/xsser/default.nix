{ lib, buildPythonApplication, fetchFromGitHub, wrapGAppsHook, gobject-introspection, gtk3, pango
, pillow, pycurl, beautifulsoup4, pygeoip, pygobject3, cairocffi, selenium }:

buildPythonApplication rec {
  pname = "xsser";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "epsylon";
    repo = pname;
    rev = "478242e6d8e1ca921e0ba8fa59b50106fa2f7312";
    sha256 = "MsQu/r1C6uXawpuVTuBGhWNqCSZ9S2DIx15Lpo7L4RI=";
  };

  postPatch = ''
    # Replace relative path with absolute store path
    find . -type f -exec sed -i "s|core/fuzzing/user-agents.txt|$out/share/xsser/fuzzing/user-agents.txt|g" {} +

    # Replace absolute path references with store paths
    substituteInPlace core/main.py --replace /usr $out
    substituteInPlace gtk/xsser.desktop --replace /usr $out
    substituteInPlace setup.py --replace /usr/share share
  '';

  # Temporary fix
  # See https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];

  buildInputs = [
    gtk3
    pango
  ];

  propagatedBuildInputs = [
    pillow
    pycurl
    beautifulsoup4
    pygeoip
    pygobject3
    cairocffi
    selenium
  ];

  # Project has no tests
  doCheck = false;

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    install -D core/fuzzing/user-agents.txt $out/share/xsser/fuzzing/user-agents.txt
  '';

  meta = with lib; {
    description = "Automatic framework to detect, exploit and report XSS vulnerabilities in web-based applications";
    homepage = "https://xsser.03c8.net/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emilytrau ];
  };
}
