{ lib
, stdenv
, fetchFromGitLab
, python3Packages
, asciidoc
, makeWrapper
, iw
}:

stdenv.mkDerivation rec {
  pname = "networkd-dispatcher";
  version = "2.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "craftyguy";
    repo = pname;
    rev = version;
    hash = "sha256-yO9/HlUkaQmW/n9N3vboHw//YMzBjxIHA2zAxgZNEv0=";
  };

  patches = [
    # Support rule files in NixOS store paths. Required for the networkd-dispatcher
    # module to work
    ./support_nix_store_path.patch
  ];

  postPatch = ''
    # Fix paths in systemd unit file
    substituteInPlace networkd-dispatcher.service \
      --replace "/usr/bin/networkd-dispatcher" "$out/bin/networkd-dispatcher" \
      --replace "/etc/conf.d" "$out/etc/conf.d"
    # Remove conditions on existing rules path
    sed -i '/ConditionPathExistsGlob/g' networkd-dispatcher.service
  '';

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    python3Packages.wrapPython
  ];

  checkInputs = with python3Packages; [
    dbus-python
    iw
    mock
    pygobject3
    pytestCheckHook
  ];

  pythonPath = with python3Packages; [
    configparser
    dbus-python
    pygobject3
  ];

  installPhase = ''
    runHook preInstall
    install -D -m755 -t $out/bin networkd-dispatcher
    install -Dm644 networkd-dispatcher.service $out/lib/systemd/system/networkd-dispatcher.service
    install -Dm644 networkd-dispatcher.conf $out/etc/conf.d/networkd-dispatcher.conf
    install -D networkd-dispatcher.8 -t $out/share/man/man8/
    runHook postInstall
  '';

  doCheck = true;

  postFixup = ''
    wrapPythonPrograms
    wrapProgram $out/bin/networkd-dispatcher --prefix PATH : ${lib.makeBinPath [ iw ]}
  '';

  meta = with lib; {
    description = "Dispatcher service for systemd-networkd connection status changes";
    homepage = "https://gitlab.com/craftyguy/networkd-dispatcher";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
