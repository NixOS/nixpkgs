{ stdenv, fetchgit, python36, udev, coreutils }:

stdenv.mkDerivation rec {
  pname = "acpilight";
  version = "1.1";

  src = fetchgit {
    url = "https://gitlab.com/wavexx/acpilight.git";
    rev = "v${version}";
    sha256 = "0kykrl71fb146vaq8207c3qp03h2djkn8hn6psryykk8gdzkv3xd";
  };

  pyenv = python36.withPackages (pythonPackages: with pythonPackages; [
    ConfigArgParse
  ]);

  postConfigure = ''
    substituteInPlace 90-backlight.rules --replace /bin ${coreutils}/bin
  '';

  buildInputs = [ pyenv udev ];

  makeFlags = [ "DESTDIR=$(out) prefix=" ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/wavexx/acpilight";
    description = "ACPI backlight control";
    license = licenses.gpl3;
    maintainers = with maintainers; [ "smakarov" ];
    platforms = platforms.linux;
  };
}
