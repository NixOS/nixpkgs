{ stdenv, makeWrapper, bash-completion, cmake, fetchgit, hidapi, libusb1, pkgconfig
, qtbase, qttranslations, qtsvg }:

stdenv.mkDerivation rec {
  name = "nitrokey-app-${version}";
  version = "1.3.1";

  # We use fetchgit instead of fetchFromGitHub because of necessary git submodules
  src = fetchgit {
    url = "https://github.com/Nitrokey/nitrokey-app.git";
    rev = "v${version}";
    sha256 = "0zf2f7g5scqd5xfzvmmpvfc7d1w66rf22av0qv6s37875c61j9r9";
  };

  postPatch = ''
    substituteInPlace libnitrokey/CMakeLists.txt \
      --replace '/data/41-nitrokey.rules' '/libnitrokey/data/41-nitrokey.rules'
  '';

  buildInputs = [
    bash-completion
    hidapi
    libusb1
    qtbase
    qttranslations
    qtsvg
  ];
  nativeBuildInputs = [
    cmake
    pkgconfig
    makeWrapper
  ];
  cmakeFlags = "-DCMAKE_BUILD_TYPE=Release";

  postFixup = ''
    wrapProgram $out/bin/nitrokey-app \
      --prefix QT_PLUGIN_PATH : "${qtbase}/${qtbase.qtPluginPrefix}"
  '';

  meta = with stdenv.lib; {
    description      = "Provides extra functionality for the Nitrokey Pro and Storage";
    longDescription  = ''
       The nitrokey-app provides a QT system tray widget with wich you can
       access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
       See https://www.nitrokey.com/ for more information.
    '';
    homepage         = https://github.com/Nitrokey/nitrokey-app;
    repositories.git = https://github.com/Nitrokey/nitrokey-app.git;
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ kaiha fpletz ];
  };
}
