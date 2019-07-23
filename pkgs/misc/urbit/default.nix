{ stdenv, fetchFromGitHub }:

let

  pname = "urbit";

  version = "0.8.0";

  urbit-derivs = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "047x05mm23kljy9yr8fi3hg6ygiikq4ll8fy7s3k8w3z6b43y7i6";
  };

in

  with import urbit-derivs;

  urbit.overrideAttrs (_: {
    inherit pname version;

    meta = with stdenv.lib; {
      description = "A personal server operating function";
      homepage = https://urbit.org;
      license = licenses.mit;
      maintainers = with maintainers; [ jtobin ];
      platforms = with platforms; linux ++ darwin;
    };
  })

