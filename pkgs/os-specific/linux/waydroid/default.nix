{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, dnsmasq
, gawk
, getent
, gobject-introspection
, gtk3
, kmod
, lxc
, iproute2
, iptables
, util-linux
, wrapGAppsHook3
, wl-clipboard
, runtimeShell
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
  version = "1.4.2";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-/dFvhiK3nCOOmAtrYkQEB8Ge8Rf1ea5cDO7puTwS5bI=";
  };

  patches = [
    # https://github.com/waydroid/waydroid/pull/1218
    (fetchpatch {
      url = "https://github.com/waydroid/waydroid/commit/595e0e5b309a79fedaa07d90b9073ddcb156314c.patch";
      hash = "sha256-A+rUmJbFFhMZ5WpT+QBCTEcn82wJuvmi8Wbcsio41Nk=";
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    gbinder-python
    pyclip
    pygobject3
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;
  dontWrapPythonPrograms = true;
  dontWrapGApps = true;

  installPhase = ''
    make install PREFIX=$out USE_SYSTEMD=0
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    patchShebangs --host $out/lib/waydroid/data/scripts
    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
      --prefix PATH ":" ${lib.makeBinPath [ dnsmasq getent iproute2 iptables ]}

    wrapPythonProgramsIn $out/lib/waydroid/ "${lib.concatStringsSep " " ([
      "$out"
    ] ++ propagatedBuildInputs ++ [
      gawk
      kmod
      lxc
      util-linux
      wl-clipboard
    ])}"

    substituteInPlace $out/lib/waydroid/tools/helpers/*.py \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  meta = {
    description = "Waydroid is a container-based approach to boot a full Android system on a regular GNU/Linux system like Ubuntu";
    mainProgram = "waydroid";
    homepage = "https://github.com/waydroid/waydroid";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mcaju ];
  };
}
