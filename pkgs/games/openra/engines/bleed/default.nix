{ buildOpenRAEngine }:

buildOpenRAEngine {
  build = "bleed";
  version = "20250331";
  rev = "79454d8fd29b92cbafe8e2ba19f0269390a601eb";
  hash = "sha256-MoKbHj2sZVHv75T64PgPfHsxt0ce2+TtDjoLyQ1U7nw=";
  deps = ./deps.json;
  dotnetVersion = "8";
}
