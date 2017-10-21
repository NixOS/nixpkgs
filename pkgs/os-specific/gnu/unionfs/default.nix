{ fetchgit, stdenv, hurd, machHeaders, mig }:

let
  date = "20120313";
  rev  = "64dfa4e12d93c13b676d1cd7d86f4f4004ebfafa";
in
stdenv.mkDerivation rec {
  name = "unionfs-${date}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/unionfs.git";
    sha256 = "1c3d71112cb25f8f82719a16df936e43abcb1adb77af96c1bb100a8ad0889d65";
    inherit rev;
  };

  patchPhase =
    '' sed -i "Makefile" \
           -e 's|gcc|i586-pc-gnu-gcc|g ;
               s|-std=gnu99|-std=gnu99 -fgnu89-inline|g'
    '';

  makeFlags = [ "CC=i586-pc-gnu-gcc" ];
  buildInputs = [ hurd machHeaders ];
  nativeBuildInputs = [ mig ];

  installPhase =
    '' mkdir -p "$out/hurd"
       cp -v unionfs "$out/hurd"

       mkdir -p "$out/share/doc/${name}"
       cp -v [A-Z]* "$out/share/doc/${name}"
    '';

  meta = {
    description = "Union file system translator for GNU/Hurd";

    homepage = http://www.gnu.org/software/hurd/hurd/translator/unionfs.html;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
