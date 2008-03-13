args: with args; with debPackage;
debBuild ({
  src = fetchurl {
    url = mirror://debian/pool/(abort "Specify URL");
  };
  patch = fetchurl {
    url = mirror://debian/pool/(abort "Specify URL");
  };
  name = "${abort "Specify name"}";
  buildInputs = [];
  meta = {
    description = "${abort "Specify description"}";
  };
} // args)
