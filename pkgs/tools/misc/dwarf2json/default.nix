{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dwarf2json";
  version = "unstable-2021-04-15";

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = "dwarf2json";
    rev = "e8a1ce85dc33bf2039adc7f8a5f47f3016153720";
    sha256 = "sha256-hnS00glAcj78mZp5as63CsEn+dcr+GNEkz8iC3KM0h0=";
  };

  vendorHash = "sha256-tgs0l+sYdAxMHwVTew++keNpDyrHmevpmOBVIiuL+34=";

  meta = with lib; {
    homepage = "https://github.com/volatilityfoundation/dwarf2json";
    description = "Convert ELF/DWARF symbol and type information into vol3's intermediate JSON";
    license = licenses.vol-sl;
    maintainers = with maintainers; [ arkivm ];
    mainProgram = "dwarf2json";
  };
}
