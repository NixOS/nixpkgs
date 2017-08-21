{ stdenv, fetchFromGitHub, makeWrapper
, parted, grub2_light, p7zip
, wxGTK30, gksu }:

stdenv.mkDerivation rec {
  name = "winusb-unstable-2017-01-30";

  src = fetchFromGitHub {
    owner = "slacka";
    repo = "WinUSB";
    rev = "599f00cdfd5c931056c576e4b2ae04d9285c4192";
    sha256 = "1219425d1m4463jy85nrc5xz5qy5m8svidbiwnqicy7hp8pdwa7x";
  };

  buildInputs = [ wxGTK30 makeWrapper ];

  postInstall = ''
    # don't write data into /
    substituteInPlace $out/bin/winusb \
      --replace /media/ /tmp/winusb/

    wrapProgram $out/bin/winusb \
      --prefix PATH : ${stdenv.lib.makeBinPath [ parted grub2_light p7zip ]}
    wrapProgram $out/bin/winusbgui \
      --prefix PATH : ${stdenv.lib.makeBinPath [ gksu ]}
  '';

  meta = with stdenv.lib; {
    description = "Create bootable USB disks from Windows ISO images";
    homepage = https://github.com/slacka/WinUSB;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bjornfor gnidorah ];
    platforms = platforms.linux;
  };
}
