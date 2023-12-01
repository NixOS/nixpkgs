{ lib, stdenv, fetchFromGitHub, git }:

# Changing the variables CPPFLAGS and BUILD_CONFIG_NAME can be done by
# overriding the same-named attributes. See ./presets.nix for examples.

stdenv.mkDerivation rec {
  pname = "mkspiffs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "igrr";
    repo = "mkspiffs";
    rev = version;
    fetchSubmodules = true;
    sha256 = "1fgw1jqdlp83gv56mgnxpakky0q6i6f922niis4awvxjind8pbm1";
  };

  nativeBuildInputs = [ git ];
  buildFlags = [ "dist" ];
  installPhase = ''
    mkdir -p $out/bin
    cp mkspiffs $out/bin
  '';

  meta = with lib; {
    description = "Tool to build and unpack SPIFFS images";
    license = licenses.mit;
    homepage = "https://github.com/igrr/mkspiffs";
    maintainers = with maintainers; [ haslersn ];
    platforms = platforms.linux;
    mainProgram = "mkspiffs";
  };
}
