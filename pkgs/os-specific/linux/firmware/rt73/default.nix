{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "rt73-fw-1.8";
  src = fetchurl {
    url = "http://www.ralinktech.com/download.php?t=U0wyRnpjMlYwY3k4eU1EQTVMekF6THpNeEwyUnZkMjVzYjJGa056YzVPVE13TmpZMk9TNTZhWEE5UFQxU1ZEY3hWMTlHYVhKdGQyRnlaVjlXTVM0NEM%3D";
    name = "rt73-fw-1.8.zip";
    sha256 = "1gskm6wqp8nnz3qk44rmab6h81pkarzzphqvag4y05a8mwdarlz2";
  };

  buildInputs = [ unzip ];
  
  buildPhase = "true";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "mkdir -p $out/${name}; cp *.bin $out; cp *.txt $out/${name}";
  
  meta = {
    description = "Firmware for the Ralink RT73 wireless card";
    homepage = http://www.ralinktech.com/;
    license = "non-free";
  };
}
