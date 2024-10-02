{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gobject-introspection
, intltool
, python3
, wrapGAppsHook3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "onioncircuits";
  version = "0.7";

  src = fetchFromGitLab {
    domain = "gitlab.tails.boum.org";
    owner = "tails";
    repo = "onioncircuits";
    rev = version;
    sha256 = "sha256-O4tSbKBTmve4u8bXVg128RLyuxvTbU224JV8tQ+aDAQ=";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    wrapGAppsHook3
    python3.pkgs.distutils-extra
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    stem
  ];

  patches = [
    # Fix https://gitlab.tails.boum.org/tails/onioncircuits/-/merge_requests/4
    (fetchpatch {
      name = "fix-setuptool-package-discovery.patch";
      url = "https://gitlab.tails.boum.org/tails/onioncircuits/-/commit/4c620c77f36f540fa27041fcbdeaf05c9f57826c.patch";
      sha256 = "sha256-WXqyDa2meRMMHkHLO5Xl7x43KUGtlsai+eOVzUGUPpo=";
    })
  ];

  postInstall = ''
    mkdir -p $out/etc/apparmor.d

    cp apparmor/usr.bin.onioncircuits $out/etc/apparmor.d
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://tails.boum.org";
    description = "GTK application to display Tor circuits and streams";
    mainProgram = "onioncircuits";
    license = licenses.gpl3;
    maintainers = with maintainers; [ milran ];
  };
}

