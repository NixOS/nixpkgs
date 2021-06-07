{ lib, stdenv, fetchurl, fetchpatch, gettext, perlPackages, buildPackages }:

stdenv.mkDerivation rec {
  pname = "intltool";
  version = "0.51.0";

  src = fetchurl {
    url = "https://launchpad.net/intltool/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1karx4sb7bnm2j67q0q74hspkfn6lqprpy5r99vkn5bb36a4viv7";
  };

  # fix "unescaped left brace" errors when using intltool in some cases
  patches = [(fetchpatch {
    name = "perl5.26-regex-fixes.patch";
    urls = [
      "https://sources.debian.org/data/main/i/intltool/0.51.0-5/debian/patches/perl5.26-regex-fixes.patch"
      "https://src.fedoraproject.org/rpms/intltool/raw/d8d2ef29fb122a42a6b6678eb1ec97ae56902af2/f/intltool-perl5.26-regex-fixes.patch"
    ];
    sha256 = "12q2140867r5d0dysly72khi7b0mm2gd7nlm1k81iyg7fxgnyz45";
  })];

  nativeBuildInputs = with perlPackages; [ perl XMLParser ];
  propagatedBuildInputs = [ gettext ] ++ (with perlPackages; [ perl XMLParser ]);

  postInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    for f in $out/bin/*; do
      substituteInPlace $f --replace "${buildPackages.perl}" "${perlPackages.perl}"
    done
  '';
  meta = with lib; {
    description = "Translation helper tool";
    homepage = "https://launchpad.net/intltool/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
