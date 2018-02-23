{stdenv, fetchFromGitHub, cups}:

stdenv.mkDerivation rec {
  pname = "cups-zj-58";
  version = "2018-02-22";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "klirichek";
    repo = "zj-58";
    rev = "e4212cd";
    sha256 = "1w2qkspm4qqg5h8n6gmakzhiww7gag64chvy9kf89xsl3wsyp6pi";
  };

  buildInputs = [cups];

  installPhase = ''
    mkdir -p $out/lib/cups/filter
    cp rastertozj $out/lib/cups/filter

    mkdir -p $out/share/cups/model/zjiang
    cp ZJ-58.ppd $out/share/cups/model/zjiang/
  '';

  meta = {
    description = "CUPS filter for thermal printer Zjiang ZJ-58";
    homepage = https://github.com/klirichek/zj-58;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
    license = stdenv.lib.licenses.bsd2;
  };
}
