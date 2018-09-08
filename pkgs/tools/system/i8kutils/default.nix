{ stdenv, fetchFromGitHub, tcl, bash, acpi, makeWrapper }:

stdenv.mkDerivation rec {
  name = "i8kutils-${version}";
  version = "2018-06-03";

  src = fetchFromGitHub {
    owner = "vitorafsr";
    repo = "i8kutils";
    rev = "ade7dc70fe00b6067916a0f235ec2b5cffb41dec";
    sha256 = "1qa7ga8apavqsyxas8rh11d3bbkavlxxr90hl95h0k5sg9v583na";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace i8kmon \
      --replace '/usr/bin/env tclsh' ${tcl}/bin/tclsh \
      --replace /usr/bin/i8kfan $out/bin/i8kfan \
      --replace i8kctl $out/bin/i8kctl
    substituteInPlace i8kfan \
      --replace /bin/bash ${bash}/bin/bash \
      --replace /usr/bin/i8kctl $out/bin/i8kctl
  '';

  installPhase = ''
    mkdir -p $out/{bin,etc/modprobe.d,share/man1}
   
    cp i8kmon i8kfan i8kctl $out/bin/
    cp dell-smm-hwmon.conf $out/etc/modprobe.d
    cp i8kmon.1 $out/share/man1/
  '';

  preFixup = ''
    wrapProgram "$out/bin/i8kmon" \
      --prefix PATH : "${acpi}/bin/"
  '';

  meta = {
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ bkchr ];
    platforms = stdenv.lib.platforms.linux;
    description = "User-space programs for controlling the fans on some Dell laptops.";
  };
}
