{ stdenv, fetchFromGitHub, git }:

# We can build mkspiffs with custom CPPFLAGS by passing them in extraBuidFlags.
# The upstream has several named presets for CPPFLAGS whose names will be passed in buildConfigName.

stdenv.mkDerivation rec {
  name = "mkspiffs-${version}";
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

  meta = with stdenv.lib; {
    description = "Tool to build and unpack SPIFFS images";
    license = licenses.mit;
    homepage = https://github.com/igrr/mkspiffs;
    maintainers = with maintainers; [ haslersn ];
  };
}
