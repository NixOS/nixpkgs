{ stdenv, fetchFromGitHub, autoreconfHook, makeWrapper
, coreutils, dosfstools, findutils, gawk, gnugrep, grub2_light, ncurses, ntfs3g, parted, p7zip, utillinux, wget
, wxGTK30 }:

stdenv.mkDerivation rec {
  version = "3.2.12";
  name = "woeusb-${version}";

  src = fetchFromGitHub {
    owner = "slacka";
    repo = "WoeUSB";
    rev = "v${version}";
    sha256 = "14arz0g95favbl5vsngxm3xznva223x67a9as5n2mpf5bbkd9zx5";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [ wxGTK30 ];

  postPatch = ''
    # Emulate version smudge filter (see .gitattributes, .gitconfig).
    for file in configure.ac debian/changelog src/woeusb src/woeusb.1 src/woeusbgui.1; do
      substituteInPlace "$file" \
        --replace '@@WOEUSB_VERSION@@' '${version}'
    done

    substituteInPlace src/MainPanel.cpp \
      --replace "'woeusb " "'$out/bin/woeusb "
  '';

  postInstall = ''
    # don't write data into /
    substituteInPlace "$out/bin/woeusb" \
      --replace /media/ /run/woeusb/

    # woeusbgui launches woeusb with pkexec, which sets
    # PATH=/usr/sbin:/usr/bin:/sbin:/bin:/root/bin.  Perhaps pkexec
    # should be patched with a less useless default PATH, but for now
    # we add everything we need manually.
    wrapProgram "$out/bin/woeusb" \
      --set PATH '${stdenv.lib.makeBinPath [ coreutils dosfstools findutils gawk gnugrep grub2_light ncurses ntfs3g parted utillinux wget p7zip ]}'
  '';

  doInstallCheck = true;

  postInstallCheck = ''
    # woeusb --version checks for missing runtime dependencies.
    out_version="$("$out/bin/woeusb" --version)"
    [ "$out_version" = '${version}' ]
  '';

  meta = with stdenv.lib; {
    description = "Create bootable USB disks from Windows ISO images";
    homepage = https://github.com/slacka/WoeUSB;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bjornfor gnidorah ];
    platforms = platforms.linux;
  };
}
