{ fetchzip }:

rec {
  version = "3.3.2";
  src = fetchzip {
    url = "https://www.jool.mx/download/Jool-${version}.zip";
    sha256 = "0hc6vlxzmjrgf7vjcwprdqcbx3biq8kphks5k725mrd9rb84drgw";
  };
}
