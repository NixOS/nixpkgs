{ lib, stdenv, perl, ronn, fetchurl }:

stdenv.mkDerivation rec {
  pname = "geteltorito";
  version = "0.6";

  src = fetchurl {
    url = "https://userpages.uni-koblenz.de/~krienke/ftp/noarch/geteltorito/geteltorito-${version}.tar.gz";
    sha256 = "1gkbm9ahj2mgqrkrfpibzclsriqgsbsvjh19fr815vpd9f6snkxv";
  };

  buildInputs = [ perl ronn ];

  unpackCmd = "";
  dontBuild = true;
  configurePhase = "";
  installPhase = ''
    # reformat README to ronn markdown
    cat > README.new <<EOF
    geteltorito -- ${meta.description}
    ===========

    ## SYNOPSIS

    EOF

    # skip the first two lines
    # -e reformat function call
    # -e reformat example
    # -e make everything else (that is no code) that contains `: ` a list item
    tail -n +3 README | sed \
        -e 's/^\(call:\s*\)\(getelt.*\)$/\1`\2`/' \
        -e 's/^\(example:\s*\)\(getelt.*\)$/\1 `\2`/' \
        -e 's/^\(.*: \)/- \1/g' \
           >> README.new
    mkdir -p $out/man/man1
    ronn --roff README.new --pipe > $out/man/man1/geteltorito.1
    install -vD geteltorito $out/bin/geteltorito
  '';

  meta = with lib; {
    description = "Extract the initial/default boot image from a CD image if existent";
    homepage = "https://userpages.uni-koblenz.de/~krienke/ftp/noarch/geteltorito/";
    maintainers = [ maintainers.Profpatsch ];
    license = licenses.gpl2;
    mainProgram = "geteltorito";
  };

}
