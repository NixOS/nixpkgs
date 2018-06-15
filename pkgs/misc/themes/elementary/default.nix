{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "elementary-gtk-theme-${version}";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = version;
    sha256 = "1749byc2lbxmprladn9n7k6jh79r8ffgayjn689gmqsrm6czsmh2";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/elementary
    cp -r gtk-* plank $out/share/themes/elementary
  '';

  meta = with stdenv.lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = https://github.com/elementary/stylesheet;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ davidak ];
  };
}
