{ lib, stdenv, fetchurl, libbsd }:

stdenv.mkDerivation rec {
  pname = "rs";
  version = "20200313";

  src = fetchurl {
    url = "https://www.mirbsd.org/MirOS/dist/mir/rs/${pname}-${version}.tar.gz";
    sha256 = "0gxwlfk7bzivpp2260w2r6gkyl7vdi05cggn1fijfnp8kzf1b4li";
  };

  buildInputs = [ libbsd ];

  buildPhase = ''
    ${stdenv.cc}/bin/cc utf8.c rs.c -o rs -lbsd
  '';

  installPhase = ''
    install -Dm 755 rs -t $out/bin
    install -Dm 644 rs.1 -t $out/share/man/man1
  '';

  meta = with lib; {
    description = "Reshape a data array from standard input";
    longDescription = ''
      rs reads the standard input, interpreting each line as a row of blank-
      separated entries in an array, transforms the array according to the op-
      tions, and writes it on the standard output. With no arguments (argc < 2)
      it transforms stream input into a columnar format convenient for terminal
      viewing, i.e. if the length (in bytes!) of the first line is smaller than
      the display width, -et is implied, -t otherwise.

      The shape of the input array is deduced from the number of lines and the
      number of columns on the first line. If that shape is inconvenient, a more
      useful one might be obtained by skipping some of the input with the -k
      option. Other options control interpretation of the input columns.

      The shape of the output array is influenced by the rows and cols specifi-
      cations, which should be positive integers. If only one of them is a po-
      sitive integer, rs computes a value for the other which will accommodate
      all of the data. When necessary, missing data are supplied in a manner
      specified by the options and surplus data are deleted. There are options
      to control presentation of the output columns, including transposition of
      the rows and columns.
    '';

    homepage = "https://www.mirbsd.org/htman/i386/man1/rs.htm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
