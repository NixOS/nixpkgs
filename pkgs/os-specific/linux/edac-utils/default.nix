{ stdenv, fetchFromGitHub, perl, makeWrapper
, sysfsutils, dmidecode, kmod }:

stdenv.mkDerivation {
  name = "edac-utils-2015-01-07";

  src = fetchFromGitHub {
    owner = "grondo";
    repo = "edac-utils";
    rev = "f9aa96205f610de39a79ff43c7478b7ef02e3138";
    sha256 = "1dmfqb15ffldl5zirbmwiqzpxbcc2ny9rpfvxcfvpmh5b69knvdg";
  };

  nativeBuildInputs = [ perl makeWrapper ];
  buildInputs = [ sysfsutils ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  postInstall = ''
    wrapProgram "$out/sbin/edac-ctl" \
      --set PATH : "" \
      --prefix PATH : "${dmidecode}/bin" \
      --prefix PATH : "${kmod}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/grondo/edac-utils;
    description = "Handles the reporting of hardware-related memory errors";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
