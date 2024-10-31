{ lib, stdenv, gcc-arm-embedded, binutils-arm-embedded, makeWrapper
, python3Packages, fetchgit

# Extra options
, vid ? "234b", pid ? "0000"
}:

stdenv.mkDerivation {
  pname = "gnuk";

  version = "1.2.14";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "177ef67edfa2306c2a369a037362385c354083e1";
    sha256 = "16wa3xsaq4r8caw6c24hnv4j78bklacix4in2y66j35h68ggr3j1";
  };

  nativeBuildInputs = [ gcc-arm-embedded binutils-arm-embedded makeWrapper ];
  buildInputs = with python3Packages; [ python pyusb colorama ];

  configurePhase = ''
    cd src
    patchShebangs configure
    ./configure --vidpid=${vid}:${pid}
  '';

  installPhase = ''
    mkdir -p $out/bin

    find . -name gnuk.bin -exec cp {} $out \;

    #sed -i 's,Exception as e,IOError as e,' ../tool/stlinkv2.py
    sed -i ../tool/stlinkv2.py \
      -e "1a import array" \
      -e "s,\(data_received =\) (),\1 array.array('B'),g" \
      -e "s,\(data_received\) = data_received + \(.*\),\1.extend(\2),g"
    cp ../tool/stlinkv2.py $out/bin/stlinkv2
    wrapProgram $out/bin/stlinkv2 --prefix PYTHONPATH : "$PYTHONPATH"

    # Some useful helpers
    echo "#! ${stdenv.shell} -e" | tee $out/bin/{unlock,flash}
    echo "$out/bin/stlinkv2 -u \$@" >> $out/bin/unlock
    echo "$out/bin/stlinkv2 -b \$@ $out/gnuk.bin" >> $out/bin/flash
    chmod +x $out/bin/{unlock,flash}
  '';

  meta = with lib; {
    homepage = "https://www.fsij.org/doc-gnuk/";
    description = "Implementation of USB cryptographic token for gpg";
    license = licenses.gpl3;
    platforms = with platforms; linux;
  };
}
