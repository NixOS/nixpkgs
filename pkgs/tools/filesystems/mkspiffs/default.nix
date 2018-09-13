{ stdenv, fetchgit, git,  }:

stdenv.mkDerivation rec {
  name = "mkspiffs-${version}";
  version = "0.2.3";

  src = fetchgit {
    url = "https://github.com/igrr/mkspiffs";
    rev = version;
    deepClone = true;
    sha256 = "0lgw8iyz57qc2l9nvn054cpsl3piik4n63gw7bp7rpci03xazi9j";
  };

  nativeBuildInputs = [ git ];
  installPhase = ''
    make dist
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