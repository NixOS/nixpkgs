{ stdenv, fetchFromGitHub, pkgconfig, meson, vala, ninja
, gtk3, poppler, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pdftag";
  name = "${pname}-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "arrufat";
    repo = pname;
    rev = version;
    sha256 = "17zk42h0n33b4p8fqlq2riqwcdi8y9m5n0ccydnk6a4x8rli97b3";
  };

  nativeBuildInputs = [ pkgconfig meson ninja wrapGAppsHook ];
  buildInputs = [ gtk3 poppler vala ];

  patchPhase = ''substituteInPlace meson.build \
    --replace "install_dir: '/usr" "install_dir: '$out"
  '';

  preInstall = "mkdir -p $out/share/licenses/${pname}";

  meta = with stdenv.lib; {
    description = "Edit metadata found in PDFs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.unix;
  };
}
