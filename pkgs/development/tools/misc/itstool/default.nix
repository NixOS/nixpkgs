{ stdenv, lib, fetchurl, python3 }:

stdenv.mkDerivation rec {
  name = "itstool-2.0.6";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "1acjgf8zlyk7qckdk19iqaca4jcmywd7vxjbcs1mm6kaf8icqcv2";
  };

  buildInputs = [ (python3.withPackages(ps: with ps; [ libxml2 ])) ];

  # bin/itstool's shebang is "#!${python3.withPackages(...)/bin/python} -s"
  # withPackages' shebang is "#!#{bash}/bin/bash -e
  #
  # macOS won't allow the target of a shebang to be an interpreted script,
  # causing bin/itstool to get interpreted as bash.
  #
  # By prefixing /usr/bin/env to the shebang, we have env fork/exec the python
  # wrapper, which is perfectly happy to execute an interpreted script.
  #
  # However, we don't want to do this on Linux, which only allows one argument
  # in a shebang.
  postFixup = lib.optionalString stdenv.isDarwin ''
    substituteInPlace $out/bin/itstool \
      --replace "#!/" "#!/usr/bin/env /"
  '';

  meta = {
    homepage = http://itstool.org/;
    description = "XML to PO and back again";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
