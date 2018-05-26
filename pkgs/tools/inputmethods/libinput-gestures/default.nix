{ lib, stdenv, fetchFromGitHub, makeWrapper,
  libinput, wmctrl,
  xdotool ? null,
  extraUtilsPath ? lib.optional (xdotool != null) xdotool
}:
stdenv.mkDerivation rec {
  pname = "libinput-gestures";
  version = "2.33";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "bulletmark";
    repo = "libinput-gestures";
    rev = version;
    sha256 = "0a4zq880da1rn0mxn1sq4cp6zkw4bfslr0vjczkbj4immjrj422j";
  };
  patches = [
    ./0001-hardcode-name.patch
    ./0002-paths.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch =
    ''
      substituteInPlace libinput-gestures-setup --replace /usr/ /

      substituteInPlace libinput-gestures \
        --replace      /etc     "$out/etc" \
        --subst-var-by libinput "${libinput}/bin/libinput" \
        --subst-var-by wmctrl   "${wmctrl}/bin/wmctrl"
    '';
  installPhase =
    ''
      runHook preInstall
      ${stdenv.shell} libinput-gestures-setup -d "$out" install
      runHook postInstall
    '';
  postFixup =
    ''
      rm "$out/bin/libinput-gestures-setup"
      substituteInPlace "$out/share/applications/libinput-gestures.desktop" --replace "/usr" "$out"
      chmod +x "$out/share/applications/libinput-gestures.desktop"
      wrapProgram "$out/bin/libinput-gestures" --prefix PATH : "${lib.makeBinPath extraUtilsPath}"
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/bulletmark/libinput-gestures;
    description = "Gesture mapper for libinput";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ teozkr ];
  };
}
